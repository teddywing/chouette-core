module BreadcrumbHelper
  def breadcrumb_name(object, prop='name')
    "#{object.class.model_name.human} #{object.public_send(prop)}".truncate(50)
  end
end
