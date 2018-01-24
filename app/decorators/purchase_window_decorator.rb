class PurchaseWindowDecorator < AF83::Decorator
  decorates Chouette::PurchaseWindow

  create_action_link do |l|
    l.content t('purchase_windows.actions.new')
    l.href { h.new_referential_purchase_window_path(context[:referential]) }
  end

  with_instance_decorator do |instance_decorator|
    instance_decorator.show_action_link do |l|
      l.content t('purchase_windows.actions.show')
      l.href do
        h.referential_purchase_window_path(
          context[:referential],
          object
        )
      end
    end

    instance_decorator.edit_action_link do |l|
      l.href do
        h.edit_referential_purchase_window_path(context[:referential].id, object)
      end
    end

    instance_decorator.destroy_action_link do |l|
      l.href do
        h.referential_purchase_window_path(context[:referential].id, object)
      end
      l.data confirm: h.t('purchase_windows.actions.destroy_confirm')
    end
  end

  define_instance_method :bounding_dates do
    unless object.date_ranges.empty?
      object.date_ranges.map(&:min).min..object.date_ranges.map(&:max).max
    end
  end

end
