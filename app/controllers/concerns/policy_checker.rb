module PolicyChecker
  extend ActiveSupport::Concern

  included do
    before_action :check_policy, only: [:edit, :update, :destroy]
  end

  protected
  def check_policy
    authorize resource
  end
end
