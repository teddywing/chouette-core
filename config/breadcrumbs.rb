crumb :root do
  link "Accueil", root_path
end

crumb :workbench do |workbench|
  link workbench.name, workbench_path(workbench)
end

crumb :referential do |referential|
  link referential.name, referential_path(referential)
  parent :workbench, referential.workbench
end

crumb :time_tables do |referential|
  link I18n.t('time_tables.index.title'), referential_time_tables_path(referential)
  parent :referential, referential
end

crumb :time_table do |referential, time_table|
  link time_table.comment, referential_time_table_path(referential, time_table)
  parent :time_tables, referential
end

crumb :compliance_check_sets do |workbench|
  link I18n.t('compliance_check_sets.index.title'), workbench_compliance_check_sets_path(workbench)
  parent :workbench, workbench
end

crumb :compliance_check_set do |workbench, compliance_check_set|
  link compliance_check_set.name, workbench_compliance_check_set_path(workbench, compliance_check_set)
  parent :compliance_check_sets, workbench
end

crumb :imports do |workbench|
  link I18n.t('imports.index.title'), workbench_imports_path(workbench)
  parent :workbench, workbench
end

crumb :import do |workbench, import|
  link import.name, workbench_import_path(workbench, import)
  parent :imports, workbench
end

crumb :organisation do |organisation|
  link organisation.name, organisation_path(organisation)
end

crumb :compliance_control_sets do
  link I18n.t('compliance_control_sets.index.title'), compliance_control_sets_path
end

crumb :compliance_control_set do |compliance_control_set|
  link compliance_control_set.name, compliance_control_set_path(compliance_control_set)
  parent :compliance_control_sets
end

crumb :compliance_control do |compliance_control|
  link compliance_control.name, compliance_control_set_compliance_control_path(compliance_control.compliance_control_set, compliance_control)
  parent :compliance_control_set, compliance_control.compliance_control_set
end

crumb :stop_area_referential do |stop_area_referential|
  link I18n.t('stop_area_referentials.show.title'), stop_area_referential_path(stop_area_referential)
end

crumb :line_referential do |line_referential|
  link I18n.t('line_referentials.show.title'), line_referential_path(line_referential)
end

crumb :companies do |line_referential|
  link I18n.t('companies.index.title'), line_referential_companies_path(line_referential)
  parent :line_referential, line_referential
end

crumb :company do |company|
  link company.name, line_referential_company_path(company.line_referential, company)
  parent :companies, company.line_referential
end

crumb :networks do |line_referential|
  link I18n.t('networks.index.title'), line_referential_networks_path(line_referential)
  parent :line_referential, line_referential
end

crumb :network do |network|
  link network.name, line_referential_network_path(network.line_referential, network)
  parent :networks, network.line_referential
end

crumb :group_of_lines do |line_referential|
  link I18n.t('group_of_lines.index.title'), line_referential_group_of_lines_path(line_referential)
  parent :line_referential, line_referential
end

crumb :group_of_line do |group_of_line|
  link group_of_line.name, line_referential_group_of_line_path(group_of_line.line_referential, group_of_line)
  parent :group_of_lines, group_of_line.line_referential
end

crumb :lines do |line_referential|
  link I18n.t('lines.index.title'), line_referential_lines_path
  parent :line_referential, line_referential
end

crumb :line do |line|
  link line.name, line_referential_line_path(line.line_referential, line)
  parent :lines, line.line_referential
end

crumb :calendars do
  link I18n.t('calendars.index.title'), calendars_path
end

crumb :calendar do |calendar|
  link calendar.name, calendar_path(calendar)
  parent :calendars
end
# crumb :compliance_controls do|compliance_control_sets|
#   link
#   parent :compliance_control_sets, compliance_control_sets
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
