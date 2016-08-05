namespace :organisations do
  def api_retrieve_organisation
    conf = Rails.application.config.try(:stif_portail_api)
    raise 'Rails.application.config.stif_portail_api settings is not defined' unless conf

    conn = Faraday.new(:url => conf[:url]) do |c|
      c.headers['Authorization'] = "Token token=\"#{conf[:key]}\""
      c.request  :url_encoded
      c.adapter  Faraday.default_adapter
    end

    resp = conn.get '/api/v1/organizations'
    JSON.parse resp.body if resp.status == 200
  end

  def sync_organisations data
    data.each do |org|
      Organisation.sync_or_create(code: org['code'], name: org['name']).tap do |organisation|
        organisation.name      = org['name']
        organisation.synced_at = Time.now
        organisation.save if organisation.changed?
        puts "✓ Organisation #{organisation.name} has been updated" unless Rails.env.test?
      end
    end
  end

  desc "Sync organisations from stif portail"
  task sync: :environment  do
    data = api_retrieve_organisation
    sync_organisations(data) if data
  end
end
