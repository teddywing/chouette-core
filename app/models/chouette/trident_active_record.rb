module Chouette
  class TridentActiveRecord < Chouette::ActiveRecord

    self.abstract_class = true

    def referential
      @referential ||= Referential.where(:slug => Apartment::Tenant.current).first!
    end

    def workgroup
      referential&.workgroup
    end

    def hub_restricted?
      referential.data_format == "hub"
    end

    def prefix
      referential.prefix
    end

  end
end
