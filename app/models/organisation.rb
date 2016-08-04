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

  has_many :offer_workbenches

  validates :name, :presence => true, :uniqueness => true

  after_create :add_rule_parameter_set

  def add_rule_parameter_set
    RuleParameterSet.default_for_all_modes( self).save
  end

  def self.sync_or_create code:, name:
    find_or_create_by(code: code) do |org|
      org.name      = name
      org.code      = code
      org.synced_at = Time.now
    end
  end
end
