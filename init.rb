require 'redmine'

Redmine::Plugin.register :redmine_exporter do
  name 'Redmine Issue Exporter'
  author 'Cesar Celis + IA'
  description 'Export issues to Excel with journals for specific projects'
  version '1.0.0'
  url 'https://github.com/ccelis5215/redmine_exporter'
  author_url 'https://github.com/ccelis5215'
  
  project_module :issue_exporter do
    permission :export_issues, { 
      :issue_exporter => [:index, :export] 
    }, :require => :member
  end

  menu :project_menu, :issue_exporter, 
       { :controller => 'issue_exporter', :action => 'index' }, 
       :caption => :label_export_issues, 
       :after => :activity, 
       :param => :project_id

  config.after_initialize do
    require_dependency 'redmine_exporter/hooks'
  end
end