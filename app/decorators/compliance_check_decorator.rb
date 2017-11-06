class ComplianceCheckDecorator < Draper::Decorator
  delegate_all

  def action_links
    links = []
  end

end
