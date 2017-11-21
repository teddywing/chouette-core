  class StopPointDecorator < StopAreaDecorator
    decorates Chouette::StopPoint

    delegate_all

    def action_links
      super(object.stop_area)
    end
  end
