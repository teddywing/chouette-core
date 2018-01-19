module ReferentialsHelper
  # Outputs a green check icon and the text "Oui" or a red exclamation mark
  # icon and the text "Non" based on `status`
  def line_status(status)
    if status
      content_tag(:span, nil, class: 'fa fa-exclamation-circle fa-lg text-danger') +
        t('false')
    else
      content_tag(:span, nil, class: 'fa fa-check-circle fa-lg text-success') +
        t('true')
    end
  end

  def referential_overview referential
    service = ReferentialOverview.new referential, self
    render partial: "referentials/overview", locals: {referential: referential, overview: service}
  end
end
