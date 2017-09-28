module ReferentialsHelper
  # Line statuses helper
  def line_status(status)
    if status
    cls = 'danger'
      content_tag :span, status ? " #{t('false')} " : " #{t('true')}", class: "fa fa-exclamation-circle fa-lg text-#{cls}"
    else
    cls = 'success'
      content_tag :span, status ? " #{t('false')} " : " #{t('true')}", class: "fa fa-check-circle fa-lg text-#{cls}"
    end
  end
end
