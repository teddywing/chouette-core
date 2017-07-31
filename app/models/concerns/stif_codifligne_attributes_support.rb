module StifCodifligneAttributesSupport
  extend ActiveSupport::Concern

  included do
    validates_presence_of :objectid
  end

  module ClassMethods
    def object_id_key
      model_name
    end

    def model_name
      ActiveModel::Name.new self, Chouette, self.name.demodulize
    end
  end

  def objectid
    Chouette::StifCodifligneObjectid.new read_attribute(:objectid)
  end
end
