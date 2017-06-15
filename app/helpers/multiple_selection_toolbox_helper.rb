module MultipleSelectionToolboxHelper
  # Box of links that floats at the bottom right of the page
  def multiple_selection_toolbox(actions)
    links = content_tag :ul do
      delete_path = nil

      if params[:controller] = 'workbenches'
        delete_path = referentials_workbench_path
      end

      actions.map do |action|
        if action == :delete
          action_link = link_to(
            '#',
            method: :delete,
            data: {
              path: delete_path,
              confirm: 'Etes-vous sûr(e) de vouloir effectuer cette action ?'
            },
            title: t("actions.#{action}")
          ) do
            content_tag :span, '', class: 'fa fa-trash'
          end
        end

        content_tag :li, action_link, class: 'st_action'
      end.join.html_safe
    end

    label = content_tag(
      :span,
      ("<span>0</span> élément(s) sélectionné(s)").html_safe,
      class: 'info-msg'
    )

    content_tag :div, '', class: 'select_toolbox noselect' do
      links + label
    end
  end
end
