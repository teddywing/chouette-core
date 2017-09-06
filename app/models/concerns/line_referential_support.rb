module LineReferentialSupport
  extend ActiveSupport::Concern

  included do
    belongs_to :line_referential
    alias_method :referential, :line_referential
  end

  def hub_restricted?
    false
  end
end
