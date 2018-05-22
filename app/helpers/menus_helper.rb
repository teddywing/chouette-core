module MenusHelper
  def main_nav_menu_item label, &block
    @current_menu_item_count ||= 0
    @current_menu_item_count += 1
    content_tag :div, class: "menu-item panel" do
      out = ""
      out += content_tag(:div, class: "panel-heading") do
        content_tag :h4, class: "panel-title" do
          link_to label, "#menu-item-#{@current_menu_item_count}", data: {toggle: 'collapse', parent: '#menu-items'}, 'aria-expanded' => 'false'
        end
      end
      out += content_tag(:div, class: "panel-collapse collapse", id: "menu-item-#{@current_menu_item_count}") do
        content_tag :li, class: "list-group" do
          capture(&block)
        end
      end
      out.html_safe
    end
  end
end

# .menu-item.panel
#   .panel-heading
#     h4.panel-title
#       = link_to '#miOne', data: {toggle: 'collapse', parent: '#menu-items'}, 'aria-expanded' => 'false' do
#         = t('layouts.navbar.current_offer.other')
#
#   #miOne.panel-collapse.collapse
#     .list-group
#       = link_to root_path, class: "list-group-item" do
#         span = t('layouts.navbar.dashboard')
#       = link_to workbench_output_path(workbench), class: 'list-group-item' do
#         span = t('layouts.navbar.workbench_outputs.organisation')
#       = link_to '#', class: 'list-group-item disabled' do
#         span = t('layouts.navbar.workbench_outputs.workgroup')
#       - if policy(workbench.workgroup).edit?
#         = link_to [:edit, workbench.workgroup], class: 'list-group-item' do
#           span = t('layouts.navbar.workbench_outputs.edit_workgroup')
