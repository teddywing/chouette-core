
RSpec.configure do | config |
  config.before(:each, type: :poltergeist) do
    Capybara.current_driver = :poltergeist
    WebMock.allow_net_connect!
    FakeWeb.allow_net_connect = true

    DatabaseCleaner.strategy = :truncation, {except: %w[spatial_ref_sys]}
    config.use_transactional_fixtures = false
  end

  config.before(:each, type: :poltergeist) do
    DatabaseCleaner.start
    Capybara.use_default_driver
    WebMock.disable_net_connect!
    FakeWeb.allow_net_connect = false

    DatabaseCleaner.strategy = :transaction
    config.use_transactional_fixtures = true

  end
end
