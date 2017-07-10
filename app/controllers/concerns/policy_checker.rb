module PolicyChecker
  extend ActiveSupport::Concern

  included do
    before_action :authorize_resource, except: [:create, :index, :new]
    before_action :authorize_resource_class, only: [:create, :index, :new]
  end

  protected
  def authorize_resource
    authorize resource
  end

  def authorize_resource_class
    authorize resource_class
  end
end
