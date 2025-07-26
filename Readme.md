# Redmine Issue Exporter Plugin

Export issues to Excel with journal history for specific projects.

## Features
- Export issues within date range
- Include all journal entries
- Custom Excel formatting
- Project-specific export (ID 146)
- Multiple UI access points

## Installation
1. Clone into Redmine's plugins directory:
   ```bash
   git clone https://github.com/ccelis5215/redmine_exporter.git plugins/redmine_exporter
   ```
2. Install dependencies
   ```bash
   bundle install   
   ```
3. Restart Redmine    
4. Configure permissions in Redmine administration

## Usage
- Go to your project page (ID 146)
- Click "Export Issues" in the project menu
- Select date range and status
- Click "Export to Excel"

## Access points
- Project menu: "Export Issues"
- Project overview page: Export button
- Issues index page: Export link in actions menu

## Requirements
- Redmine 6.x
- Ruby 3.2.x
- Axlsx gem

```text

### Important Notes

1. **Project ID Restriction**: The plugin only works for project ID 146
2. **Permissions**: Requires `export_issues` permission
3. **Dependencies**:
   - `axlsx` for Excel generation
   - `rubyzip` for compression
   
4. **UI Integration**:
   - Project menu item
   - Button on project overview page
   - Link in issues index page

To use this plugin:
1. Place in Redmine's `plugins/` directory
2. Run `bundle install`
3. Restart Redmine server
4. Grant permissions to users/groups in Redmine admin panel
5. Access via project menu for project ID 146

The export button will appear in three locations for project 146:
1. Main project menu as "Export Issues"
2. Project overview page as a contextual button
3. Issues list page in the actions menu

All exports will include the issue details and full journal history in Excel format.

```
