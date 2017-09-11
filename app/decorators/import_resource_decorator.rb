class ImportResourceDecorator < Draper::Decorator
  decorates ImportResource

  delegate_all

  def action_links
    links = []
  end

end
