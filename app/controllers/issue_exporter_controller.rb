class IssueExporterController < ApplicationController
  before_action :find_project, :authorize
  before_action :check_project_id, only: [:index, :export]
  before_action :validate_dates, only: :export

  def index
    @start_date = (params[:start_date] || 1.month.ago.to_date).to_date
    @end_date = (params[:end_date] || Date.today).to_date
    @status_id = params[:status_id]
    @statuses = IssueStatus.sorted
  end

  def export
    issues = fetch_issues
    journals_hash = fetch_journals(issues)
    project_description = @project.description.presence || "Project #{@project.name}"

    generator = IssueExporter::ExcelReportGenerator.new
    data = generator.generate(issues, journals_hash, project_description, @start_date, @end_date)

    filename = "issues_export_#{@project.identifier}_#{@start_date.strftime('%Y%m%d')}_#{@end_date.strftime('%Y%m%d')}_#{Time.now.strftime('%Y%m%d_%H%M%S')}.xlsx"
    
    send_data data, filename: filename, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  rescue => e
    flash[:error] = "Export error: #{e.message}"
    redirect_to action: 'index'
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def check_project_id
    unless @project.id == 146
      render_403
      return false
    end
  end

  def validate_dates
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    
    if @start_date > @end_date
      flash[:error] = "Start date must be before end date"
      redirect_to action: 'index'
    end
  rescue Date::Error
    flash[:error] = "Invalid date format (use YYYY-MM-DD)"
    redirect_to action: 'index'
  end

  def fetch_issues
    scope = @project.issues
              .where(created_on: @start_date.beginning_of_day..@end_date.end_of_day)
              .includes(:tracker, :priority, :status, :assigned_to, :author, :journals => [:user, :details])
              
    scope = scope.where(status_id: params[:status_id]) if params[:status_id].present?
    scope.to_a
  end

  def fetch_journals(issues)
    journals_hash = {}
    issues.each do |issue|
      journals_hash[issue.id.to_s] = issue.journals.sort_by(&:created_on)
    end
    journals_hash
  end
end