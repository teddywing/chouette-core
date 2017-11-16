module ObjectidFormatterSupport
  extend ActiveSupport::Concern

  included do
    validates_presence_of :objectid_formater_class
    
    def objectid_formater
      objectid_formater_class.new
    end

    def objectid_formater_class
      "Chouette::ObjectidFormatter::#{read_attribute(:objectid_format).camelcase}".constantize if read_attribute(:objectid_format)
    end
  end
end
