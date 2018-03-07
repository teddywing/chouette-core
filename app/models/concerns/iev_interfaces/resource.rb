module IevInterfaces::Resource
  extend ActiveSupport::Concern

  included do
    extend Enumerize
    enumerize :status, in: %i(OK ERROR WARNING IGNORED), scope: true
    validates_presence_of :name, :resource_type, :reference
  end
end
