# -*- coding: utf-8 -*-
module ExportsHelper
  def export_status status
    import_status status
  end

  def export_option_input form, export, attr, option_def, type, referentials
    if !!option_def[:depends_on_referential]
      out = ""
      referentials.each do |referential|
        out += content_tag :div, class: "slave", data: {master: "[name='export[referential_id]']", value: referential.id} do
          _opts = {depends_on_referential: false, collection: option_def[:collection].call(referential)}.reverse_update(option_def)
          export_option_input form, export, attr, _opts, type, referentials
        end
      end
      out.html_safe
    else
      opts = { required: option_def[:required], input_html: {value: export.try(attr) || option_def[:default_value]}, as: option_def[:type], selected:  export.try(attr) || option_def[:default_value]}

      if option_def.has_key?(:collection)
        if option_def[:collection].is_a?(Array) && !option_def[:collection].first.is_a?(Array)
          opts[:collection] = option_def[:collection].map{|k| [export.class.tmf("#{type.name.demodulize.underscore}.#{attr}_collection.#{k}"), k]}
        else
          opts[:collection] = option_def[:collection]
        end
        opts[:collection] = export.instance_exec(&option_def[:collection]) if option_def[:collection].is_a?(Proc)
      end
      opts[:label] =  export.class.tmf("#{type.name.demodulize.underscore}.#{attr}")
      opts[:input_html]['data-select2ed'] = true if opts[:collection]
      out = form.input attr, opts
      if option_def[:depends]
        out = content_tag :div, class: "slave", data: {master: "[name='export[#{option_def[:depends][:option]}]']", value: option_def[:depends][:value]} do
          out
        end.html_safe
      end
      out
    end
  end

  def export_message_content message
    if message.message_key == "full_text"
      message.message_attributes["text"]
    else
      t([message.class.name.underscore.gsub('/', '_').pluralize, message.message_key].join('.'), message.message_attributes&.symbolize_keys || {})
    end.html_safe
  end

  def fields_for_export_task_format(form)
    begin
      render :partial => export_partial_name(form), :locals => { :form => form }
    rescue ActionView::MissingTemplate
      ""
    end
  end

  def export_partial_name(form)
    "fields_#{form.object.format.underscore}_export"
  end

  def export_attributes_tag(export)
    content_tag :div, class: "export-attributes" do
      [].tap do |parts|
        if export.format.present?
          parts << bh_label(t("enumerize.data_format.#{export.format}"))
        end
      end.join.html_safe
    end
  end

  def compliance_icon( export_task)
    return nil unless export_task.compliance_check_task
    export_task.compliance_check_task.tap do |cct|
      if cct.failed? || cct.any_error_severity_failure?
        return 'icons/link_page_alert.png'
      else
        return 'icons/link_page.png'
      end
    end
  end

  def workgroup_exports workgroup
    Export::Base.user_visible_descendants.select{|e| workgroup.has_export? e.name}
  end
end
