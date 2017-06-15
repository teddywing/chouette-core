module MultipleSelectionToolboxHelper
  # Box of links that floats at the bottom right of the page
  def multiple_selection_toolbox(actions)
    tools = content_tag :ul do
      dPath = nil
      dPath = referentials_workbench_path if params[:controller] = 'workbenches'

      actions.collect do |action|
        if action == :edit
          actitem = link_to('#', title: t("actions.#{action}")) do
            content_tag :span, '', class: 'fa fa-pencil'
          end
        elsif action == :delete
          actitem = link_to('#', method: :delete, data: { path: dPath, confirm: 'Etes-vous sûr(e) de vouloir effectuer cette action ?' }, title: t("actions.#{action}")) do
            content_tag :span, '', class: 'fa fa-trash'
          end
        end

        content_tag :li, actitem, class: 'st_action'
      end.join.html_safe

    end
    content_tag :div, '', class: 'select_toolbox noselect' do
      tools.concat(content_tag(:span, ("<span>0</span> élément(s) sélectionné(s)").html_safe, class: 'info-msg'))
    end
  end
end
