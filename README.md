# Redmine Excel Exporter Plugin
 Export Redmine issues to Excel with full journal history for specific projects. Includes advanced formatting options and flexible access points.
 ## Features
 - **Date Range Filtering**: Export issues created or updated within a specified date range.
 - **Full Journal History**: Includes all journal entries (comments, status changes, etc.) for each issue.
 - **Custom Excel Formatting**: Professionally formatted Excel output for better readability.
 - **Project-Specific Export**: Currently configured for Project ID 146 (configurable).
 - **Multiple Access Points**: Available from three different locations within the Redmine interface.
 - **Status Filtering**: Option to export by issue status.
 ## Installation
 1. **Clone the repository** into your Redmine's `plugins` directory:
    ```bash
    git clone https://github.com/ccelis5215/redmine_exporter.git plugins/redmine_exporter
    ```
 2. **Install dependencies** using Bundler:
    ```bash
    bundle install
    ```
 3. **Restart Redmine** to load the plugin.
    For Passenger:
    ```bash
    touch tmp/restart.txt
    ```
    For other setups, restart the application server (e.g., systemctl restart apache2).
 4. **Configure permissions** in the Redmine administration panel:
    - Go to _Administration -> Roles and permissions_.
    - For each role that should have access, check the `export_issues` permission under the "Project" module.
 ## Usage
 To export issues:
 1. Navigate to the project with ID 146 (or the one you've configured).
 2. Access the exporter through any of the available UI points (see below).
 3. In the export form:
    - Select a start and end date for the issue filter.
    - Choose the issue status(es) to include (select "All" for every status).
 4. Click the "Export to Excel" button to generate and download the report.
 ## Access Points
 The export functionality is available in three places within the project (ID 146):
 | Location | UI Element |
 |----------|------------|
 | **Project navigation menu** | A menu item labeled "Export Issues" appears in the main project navigation. |
 | **Project overview page** | A button labeled "Export Issues" appears in the top-right action bar. |
 | **Issues index page** | A link labeled "Export" appears in the "Actions" dropdown menu. |
 ## Requirements
 - **Redmine version**: 6.x (tested on 6.0.0 and above)
 - **Ruby version**: 3.2.x
 - **Required gems**:
   - `axlsx` (for generating Excel files)
   - `rubyzip` (for compression)
 ## Configuration
 ### Changing the Project ID
 By default, the plugin only works for project ID 146. To change this:
 1. Edit the file `app/controllers/exporter_controller.rb` in the plugin directory.
 2. Find the line that sets the project ID (look for `@project = Project.find(146)`).
 3. Change `146` to your desired project ID.
 Alternatively, you can modify the plugin to work for multiple projects by changing the logic.
 ### Permissions
 The `export_issues` permission must be enabled for the relevant roles. This can be done in:
   _Administration -> Roles and permissions -> [Select Role] -> Permissions (Project module)_
 ## Important Notes
 - **Performance**: Exporting large numbers of issues with extensive journal histories may take significant time and memory.
 - **File Format**: The exported file is in the modern `.xlsx` format.
 - **Dependencies**: Ensure all required gems are installed. If you encounter issues during installation, run `bundle update`.
 ## Troubleshooting
 - **Plugin not appearing**: 
   - Verify the plugin is in the `plugins/redmine_exporter` directory.
   - Check for any installation errors during `bundle install`.
   - Restart Redmine.
 - **Export option not visible in project**:
   - Confirm you are in project ID 146 (or the configured project).
   - Check the user role has the `export_issues` permission.
 - **Errors during export**:
   - Check the Redmine logs (`log/production.log`) for detailed error messages.
   - Ensure the `axlsx` and `rubyzip` gems are properly installed.
 - **Permission denied errors**:
   - Recheck the role permissions in the administration panel.
 ## Support
 For issues and feature requests, please visit the [GitHub repository](https://github.com/ccelis5215/redmine_exporter).
