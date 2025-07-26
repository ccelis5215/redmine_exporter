module RedmineExporter
  class Hooks < Redmine::Hook::ViewListener
    # Add button to project overview page
    def view_projects_show_left(context = {})
      project = context[:project]
      controller = context[:controller]
      
      if project.id == 146 && User.current.allowed_to?(:export_issues, project)
        controller.send(:render_to_string, {
          partial: 'projects/export_button',
          locals: context
        })
      else
        ''
      end
    end

    # Add button to issues index page
    def view_issues_index_actions(context = {})
      project = context[:project]
      controller = context[:controller]
      
      if project.id == 146 && User.current.allowed_to?(:export_issues, project)
        controller.send(:render_to_string, {
          partial: 'issues/index_export_button',
          locals: context
        })
      else
        ''
      end
    end
  end
end