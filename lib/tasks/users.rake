namespace :users do
  def api_retrieve_user
    conf = Rails.application.config.try(:stif_portail_api)
    raise 'Rails.application.config.stif_portail_api settings is not defined' unless conf

    conn = Faraday.new(:url => conf[:url]) do |c|
      c.headers['Authorization'] = "Token token=\"#{conf[:key]}\""
      c.adapter  Faraday.default_adapter
    end

    resp = conn.get '/api/v1/users'
    if resp.status == 200
      JSON.parse resp.body
    else
      raise "Error on api request status : #{resp.status} => #{resp.body}"
    end
  end

  def sync_users data
    data.each do |el|
      User.find_or_create_by(username: el['username']).tap do |user|
        user.name         = "#{el['firstname']} #{el['lastname']}"
        user.email        = el['email']
        user.synced_at    = Time.now

        # Set organisation
        user.organisation = Organisation.find_or_create_by(code: el['organization_code']).tap do |org|
          org.name      = el['organization_name']
          org.synced_at = Time.now
        end

        user.save if user.changed?
        puts "✓ user #{user.username} has been updated" unless Rails.env.test?
      end
    end
  end

  desc "Sync users from stif portail"
  task sync: :environment  do
    data = api_retrieve_user
    sync_users(data) if data
  end
end
