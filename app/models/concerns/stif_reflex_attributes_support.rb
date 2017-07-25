module StifReflexAttributesSupport
  extend ActiveSupport::Concern

  included do
    validates_presence_of :objectid
  end

  def objectid
    Chouette::StifReflexObjectid.new read_attribute(:objectid).to_s
  end

end
