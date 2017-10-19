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
  link :time_tables, referential_time_tables_path(referential)
  parent :referential, referential
end

crumb :time_table do |referential, time_table|
  link time_table.comment, referential_time_table_path(referential, time_table)
  parent :time_tables, referential
end

crumb :compliance_check_sets do |workbench|
  link :compliance_check_sets, workbench_compliance_check_sets_path(workbench)
  parent :workbench, workbench
end

crumb :compliance_check_set do |workbench, compliance_check_set|
  link :compliance_check_set, workbench_compliance_check_set_path(workbench, compliance_check_set)
  parent :compliance_check_sets, workbench
end

crumb :imports do |workbench|
  link :imports, workbench_imports_path(workbench)
  parent :workbench, workbench
end

crumb :import do |workbench, import|
  link import.name, workbench_import_path(workbench, import)
  parent :imports, workbench
end

crumb :organisation do |organisation|
  link organisation.name, organisation_path(organisation)
end


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
