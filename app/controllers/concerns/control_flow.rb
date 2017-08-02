module ControlFlow
  FinishAction = Class.new RuntimeError

  def self.included into
    into.rescue_from FinishAction, with: :catch_finish_action
  end

  # Allow to exit locally inside an action after rendering (especially in error cases)
  def catch_finish_action; end

  def finish_action! msg = 'finish action'
    raise FinishAction, msg
  end
end
