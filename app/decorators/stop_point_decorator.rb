class StopPointDecorator < StopAreaDecorator
  decorates Chouette::StopPoint

  delegate_all

  def action_links
    common_action_links(object.stop_area).flatten
  end
end
