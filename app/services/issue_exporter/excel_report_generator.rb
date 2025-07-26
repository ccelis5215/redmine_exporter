module IssueExporter
  class ExcelReportGenerator
    def generate(issues, journals, project_description, start_date, end_date)
      Axlsx::Package.new do |p|
        p.workbook.add_worksheet(name: 'Issues') do |sheet|
          add_headers(sheet)
          add_data_rows(sheet, issues, journals)
          apply_styles(sheet)
        end
        p.to_stream.read
      end
    end

    private

    def add_headers(sheet)
      headers = [
        'ID', 'Tracker', 'Title', 'Description', 'Priority',
        'Status', 'Assigned To', 'Start Date', 'Closed Date',
        'Duration (minutes)', 'Duration (hh:mm:ss)', 'Created By',
        'Journal #', 'Journal User', 'Journal Date', 'Journal Notes', 'Journal Changes'
      ]
      sheet.add_row headers
    end

    def add_data_rows(sheet, issues, journals)
      issues.each do |issue|
        base_data = base_issue_data(issue)
        issue_journals = journals[issue.id.to_s] || []
        
        if issue_journals.empty?
          sheet.add_row(base_data.values)
        else
          issue_journals.each_with_index do |journal, idx|
            row = base_data.dup
            clear_issue_specific_fields!(row) if idx > 0
            row.merge!(journal_data(journal, idx + 1))
            sheet.add_row(row.values)
          end
        end
      end
    end

    def base_issue_data(issue)
      created_on = format_datetime(issue.created_on)
      closed_on = issue.closed? ? format_datetime(issue.updated_on) : nil
      duration_minutes = calculate_duration(created_on, closed_on)
      
      {
        'ID' => issue.id,
        'Tracker' => issue.tracker&.name,
        'Title' => issue.subject,
        'Description' => issue.description,
        'Priority' => issue.priority&.name,
        'Status' => issue.status&.name,
        'Assigned To' => issue.assigned_to&.name,
        'Start Date' => created_on,
        'Closed Date' => closed_on,
        'Duration Min' => duration_minutes,
        'Duration HHMMSS' => format_duration(duration_minutes),
        'Created By' => issue.author&.name,
        'Journal #' => nil,
        'Journal User' => nil,
        'Journal Date' => nil,
        'Journal Notes' => nil,
        'Journal Changes' => nil
      }
    end

    def journal_data(journal, index)
      {
        'Journal #' => index,
        'Journal User' => journal.user&.name || 'Unknown User',
        'Journal Date' => format_datetime(journal.created_on),
        'Journal Notes' => journal.notes.presence || 'No notes',
        'Journal Changes' => format_journal_details(journal.details)
      }
    end

    def clear_issue_specific_fields!(row)
      %w[Tracker Title Description Priority Status Assigned_To Start_Date Closed_Date Duration_Min Duration_HHMMSS Created_By].each do |field|
        row[field] = nil
      end
    end

    def format_datetime(datetime)
      return nil unless datetime
      datetime.localtime.strftime('%Y-%m-%d %H:%M:%S')
    rescue
      nil
    end

    def calculate_duration(start_time, end_time)
      return nil unless start_time && end_time
      begin
        start_dt = Time.zone.parse(start_time)
        end_dt = Time.zone.parse(end_time)
        ((end_dt - start_dt) / 60).round(2)
      rescue
        nil
      end
    end

    def format_duration(minutes)
      return nil unless minutes
      hours = minutes.to_i / 60
      minutes_remaining = minutes.to_i % 60
      seconds = ((minutes - minutes.to_i) * 60).round
      format("%02d:%02d:%02d", hours, minutes_remaining, seconds)
    end

    def format_journal_details(details)
      return 'No changes' if details.blank?
      details.map do |d|
        "#{d.property}.#{d.prop_key}: '#{d.old_value}' → '#{d.new_value}'"
      end.join('; ')
    end

    def apply_styles(sheet)
      header_style = sheet.styles.add_style(
        b: true,
        bg_color: 'CCCCCC',
        alignment: { horizontal: :center, vertical: :center }
      )
      sheet.rows.first.style = header_style
      
      wrap_style = sheet.styles.add_style(alignment: { wrap_text: true })
      [2, 3, 14, 15].each { |col_idx| sheet.col_style(col_idx, wrap_style) }
      
      sheet.column_widths *[:auto] * sheet.column_info.size
    end
  end
end