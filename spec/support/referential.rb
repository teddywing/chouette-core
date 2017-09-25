module ReferentialHelper

  def first_referential
    Referential.find_by!(:slug => "first")
  end

  def first_organisation
    Organisation.find_by!(code: "first")
  end

  def self.included(base)
    base.class_eval do
      extend ClassMethods
      alias_method :referential, :first_referential
      alias_method :organisation, :first_organisation
    end
  end

  module ClassMethods

    def assign_referential
      before(:each) do
        assign :referential, referential
      end
    end
    def assign_organisation
      before(:each) do
        assign :organisation, referential.organisation
      end
    end


  end

end

RSpec.configure do |config|
  config.include ReferentialHelper

  config.before(:suite) do
    # Clean all tables to start
    DatabaseCleaner.clean_with :truncation, except: %w[spatial_ref_sys]
    # Truncating doesn't drop schemas, ensure we're clean here, first *may not* exist
    Apartment::Tenant.drop('first') rescue nil
    # Create the default tenant for our tests
    organisation = Organisation.create!(code: "first", name: "first")

    line_referential = LineReferential.find_or_create_by(name: "first") do |referential|
      referential.add_member organisation, owner: true
    end
    stop_area_referential = StopAreaReferential.find_or_create_by(name: "first") do |referential|
      referential.add_member organisation, owner: true
    end

    workbench = Workbench.create!(
      name: "Gestion de l'offre",
      organisation: organisation,
      line_referential: line_referential,
      stop_area_referential: stop_area_referential
    )
    referential = Referential.create! prefix: "first", name: "first", slug: "first", organisation: organisation, workbench: workbench
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    # Switch into the default tenant
    first_referential.switch
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation, { except: %w[spatial_ref_sys] }
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    # Reset tenant back to `public`
    Apartment::Tenant.reset
    # Rollback transaction
    DatabaseCleaner.clean
  end

end
