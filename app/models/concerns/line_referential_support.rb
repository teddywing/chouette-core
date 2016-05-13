module LineReferentialSupport
  extend ActiveSupport::Concern

  included do
    belongs_to :line_referential
    # validates_presence_of :line_referential_id

    alias_method :referential, :line_referential
  end

  def hub_restricted?
    false
  end

  def prefix
    # FIXME #825
    "dummy"
  end

end
