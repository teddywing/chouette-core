module DeviseRequestHelper
  include Warden::Test::Helpers

  def login_user
    organisation = Organisation.where(:code => "first").first_or_create(attributes_for(:organisation))
    @user ||= create(:user, :organisation => organisation,
      :permissions => ['routes.create', 'routes.edit', 'routes.destroy', 'journey_patterns.create', 'journey_patterns.edit', 'journey_patterns.destroy',
        'vehicle_journeys.create', 'vehicle_journeys.edit', 'vehicle_journeys.destroy', 'time_tables.create', 'time_tables.edit', 'time_tables.destroy',
        'footnotes.edit', 'footnotes.create', 'footnotes.destroy', 'routing_constraint_zones.create', 'routing_constraint_zones.edit', 'routing_constraint_zones.destroy',
        'access_points.create', 'access_points.edit', 'access_points.destroy', 'access_links.create', 'access_links.edit', 'access_links.destroy',
        'connection_links.create', 'connection_links.edit', 'connection_links.destroy', 'route_sections.create', 'route_sections.edit', 'route_sections.destroy'])
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
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      organisation = Organisation.where(:code => "first").first_or_create(attributes_for(:organisation))
      user = create(:user, :organisation => organisation,
        :permissions => ['routes.create', 'routes.edit', 'routes.destroy', 'journey_patterns.create', 'journey_patterns.edit', 'journey_patterns.destroy'])
      sign_in user
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend DeviseControllerHelper, :type => :controller

  config.include DeviseRequestHelper, :type => :request
  config.include DeviseRequestHelper, :type => :feature
end
