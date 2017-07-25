module StifCodifligneAttributesSupport
  extend ActiveSupport::Concern

  included do
    validates_presence_of :objectid
  end

  def objectid
    Chouette::StifCodifligneObjectid.new read_attribute(:objectid)
  end
end
