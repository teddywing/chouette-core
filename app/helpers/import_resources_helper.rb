# -*- coding: utf-8 -*-
module ImportResourcesHelper

  # Import statuses helper
  def import_resource_status(status)
      cls =''
      cls = 'success' if status == 'OK'
      cls = 'warning' if status == 'WARNING'
      cls = 'danger'  if status == 'ERROR'
      cls = 'alert'  if status == 'IGNORED'

      content_tag :span, '', class: "fa fa-circle text-#{cls}"
  end

end
