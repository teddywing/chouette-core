module ComplianceControlSetsHelper

  def organisations_filters_values
    [current_organisation, Organisation.find_by_name("STIF")].uniq
  end

  def flotted_links ccs_id = @compliance_control_set
    links = [new_control(ccs_id), new_block(ccs_id)]
    unless links.all? &:nil?
      content_tag :div, class: 'select_toolbox' do
        content_tag :ul do
          links.collect {|link| concat content_tag(:li, link, class: 'st_action with_text') unless link.nil?} 
        end
      end
    end
  end

  def new_control ccs_id
    if policy(ComplianceControl).create?
      link_to select_type_compliance_control_set_compliance_controls_path(ccs_id) do 
        concat content_tag :span, nil, class: 'fa fa-plus'
        concat content_tag :span, t('compliance_control_sets.actions.add_compliance_control')
      end
    else
      nil
    end
  end

  def new_block ccs_id
    if policy(ComplianceControlBlock).create?
      link_to new_compliance_control_set_compliance_control_block_path(ccs_id) do 
        concat content_tag :span, nil, class: 'fa fa-plus'
        concat content_tag :span,t('compliance_control_sets.actions.add_compliance_control_block')
      end   
    else
      nil
    end
  end
end