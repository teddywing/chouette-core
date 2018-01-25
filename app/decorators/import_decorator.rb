class ImportDecorator < AF83::Decorator
  decorates Import

  def import_status_css_class
    cls =''
    cls = 'overheaded-success' if object.status == 'successful'
    cls = 'overheaded-warning' if object.status == 'warning'
    cls = 'overheaded-danger' if %w[failed aborted canceled].include? object.status
    cls
  end

  create_action_link do |l|
    l.content t('imports.actions.new')
    l.href { h.new_workbench_import_path(workbench_id: context[:workbench]) }
  end

  with_instance_decorator do |instance_decorator|
    instance_decorator.show_action_link do |l|
      l.href { h.workbench_import_path(context[:workbench], object) }
    end

    instance_decorator.action_link secondary: :show do |l|
      l.content t('imports.actions.download')
      l.href { object.file.url }
    end
  end
end
