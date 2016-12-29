# -*- coding: utf-8 -*-
class Organisation < ActiveRecord::Base
  include DataFormatEnumerations

  has_many :users, :dependent => :destroy
  has_many :referentials, :dependent => :destroy
  has_many :rule_parameter_sets, :dependent => :destroy

  has_many :stop_area_referential_memberships
  has_many :stop_area_referentials, through: :stop_area_referential_memberships

  has_many :line_referential_memberships
  has_many :line_referentials, through: :line_referential_memberships

  has_many :workbenches
  has_many :calendars

  validates_presence_of :name
  validates_uniqueness_of :code

  after_create :add_rule_parameter_set

  def add_rule_parameter_set
    RuleParameterSet.default_for_all_modes( self).save
  end

  def self.portail_api_request
    conf = Rails.application.config.try(:stif_portail_api)
    raise 'Rails.application.config.stif_portail_api settings is not defined' unless conf

    conn = Faraday.new(:url => conf[:url]) do |c|
      c.headers['Authorization'] = "Token token=\"#{conf[:key]}\""
      c.adapter  Faraday.default_adapter
    end

    resp = conn.get '/api/v1/organizations'
    if resp.status == 200
      JSON.parse resp.body
    else
      raise "Error on api request status : #{resp.status} => #{resp.body}"
    end
  end

  def self.sync_update code, name, scope
    org = Organisation.find_or_initialize_by(code: code)
    if scope
      org.sso_attributes ||= {}
      if org.sso_attributes['functional_scope'] != scope
        org.sso_attributes['functional_scope'] = scope
        # FIXME see #1941
        org.sso_attributes_will_change!
      end
    end
    org.name      = name
    org.synced_at = Time.now
    org.save
    org
  end

  def self.portail_sync
    self.portail_api_request.each do |el|
      org = self.sync_update el['code'], el['name'], el['functional_scope']
      puts "✓ Organisation #{org.name} has been updated" unless Rails.env.test?
    end
  end
end
