module IevInterfaces::Message
  extend ActiveSupport::Concern

  included do
    extend Enumerize
    enumerize :criticity, in: %i(info warning error)
    validates :criticity, presence: true
  end
end
