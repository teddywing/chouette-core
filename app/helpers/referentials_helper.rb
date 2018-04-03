module ReferentialsHelper
  # Outputs a green check icon and the text "Oui" or a red exclamation mark
  # icon and the text "Non" based on `status`
  def line_status(status)
     if status
      content_tag(:span, nil, class: 'fa fa-exclamation-circle fa-lg text-danger') +
      t('activerecord.attributes.line.deactivated')
    else
      content_tag(:span, nil, class: 'fa fa-check-circle fa-lg text-success') +
      t('activerecord.attributes.line.activated')
    end
  end

  def referential_overview referential
    service = ReferentialOverview.new referential, self
    render partial: "referentials/overview", locals: {referential: referential, overview: service}
  end

  def referential_status referential
    if !referential.ready
      if Import::Base.failed_statuses.include?(referential_creation_status(referential)&.status)
        "<div class='td-block'><span class='fa fa-times'></span><span>#{t('activerecord.attributes.referential.creation_failed')}</span></div>".html_safe
      else
        "<div class='td-block'><span class='fa fa-spinner fa-spin'></span><span>#{t('activerecord.attributes.referential.in_creation')}</span></div>".html_safe
      end
    elsif referential.referential_read_only?
      "<div class='td-block'><span class='fa fa-archive'></span><span>#{t('activerecord.attributes.referential.archived_at')}</span></div>".html_safe
    else
      "<div class='td-block'><span class='sb sb-lg sb-preparing'></span><span>#{t('activerecord.attributes.referential.archived_at_null')}</span></div>".html_safe
    end
  end

  def referential_creation_status referential
    import = Import::Base.find_by_referential_id referential.id
    clone = ReferentialCloning.find_by_target_referential_id  referential.id
    operation = import || clone
  end

  def mutual_workbench workbench
    current_user.organisation.workbenches.where(workgroup_id: workbench.workgroup_id).last
  end

  def duplicate_workbench_referential_path referential
    workbench = mutual_workbench referential.workbench
    raise "Missing workbench for referential #{referential.name}" unless workbench.present?
    new_workbench_referential_path(workbench, from: referential.id)
  end
end
