module DeviseRequestHelper
  include Warden::Test::Helpers

  def login_user
    organisation = Organisation.where(:code => "first").first_or_create(attributes_for(:organisation))
    @user ||= create(:user, :organisation => organisation,
                     :permissions => ['routes.create', 'routes.update', 'routes.destroy', 'journey_patterns.create', 'journey_patterns.update', 'journey_patterns.destroy',
                                      'vehicle_journeys.create', 'vehicle_journeys.update', 'vehicle_journeys.destroy', 'time_tables.create', 'time_tables.update', 'time_tables.destroy',
                                      'footnotes.update', 'footnotes.create', 'footnotes.destroy', 'routing_constraint_zones.create', 'routing_constraint_zones.update', 'routing_constraint_zones.destroy',
                                      'access_points.create', 'access_points.update', 'access_points.destroy', 'access_links.create', 'access_links.update', 'access_links.destroy',
                                      'connection_links.create', 'connection_links.update', 'connection_links.destroy', 'route_sections.create', 'route_sections.update', 'route_sections.destroy',
                                      'referentials.create', 'referentials.update', 'referentials.destroy'])
    login_as @user, :scope => :user
    # post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password
  end

  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods

    def login_user
      before(:each) do
        login_user
      end
      after(:each) do
        Warden.test_reset!
      end
    end

  end

end

module DeviseControllerHelper

  def setup_user
    _all_actions = %w{create destroy update}
    _all_resources = %w{ access_links
            access_points
            connection_links
            footnotes
            journey_patterns
            referentials
            route_sections
            routes
            routing_constraint_zones
            time_tables
            vehicle_journeys }
    join_with =  -> (separator) do 
      -> (ary) { ary.join(separator) }
    end

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      organisation = Organisation.where(:code => "first").first_or_create(attributes_for(:organisation))
      @user = create(:user,
                     organisation: organisation,
                     permissions: _all_resources.product( _all_actions ).map(&join_with.('.')))
    end
  end

  def login_user()
    setup_user
    before do
      sign_in @user
    end
  end

  private

end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend DeviseControllerHelper, :type => :controller

  config.include DeviseRequestHelper, :type => :request
  config.include DeviseRequestHelper, :type => :feature
end
