crumb :root do
  link "Accueil", dashboard_path
end

crumb :workbench do |workbench|
  link workbench.name, workbench_path(workbench)
end

crumb :referential do |referential|
  link referential.name, referential_path(referential)
  parent :workbench, referential.workbench
end

crumb :time_tables do |referential|
  link t('time_tables.index.title'), referential_time_tables_path(referential)
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
