class ApplicationModel < ::ActiveRecord::Base
  include MetadataSupport

  self.abstract_class = true

  def self.referential
    Referential.where(slug: Apartment::Tenant.current).last
  end

  def referential
    self.class.referential
  end

  def self.workgroup
    referential&.workgroup
  end

  def workgroup
    self.class.workgroup
  end
end
