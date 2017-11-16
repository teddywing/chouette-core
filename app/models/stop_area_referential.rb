class StopAreaReferential < ActiveRecord::Base
  extend Enumerize
  include ObjectidFormaterSupport
  has_many :stop_area_referential_memberships
  has_many :organisations, through: :stop_area_referential_memberships

  has_many :stop_areas, class_name: 'Chouette::StopArea'
  has_many :stop_area_referential_syncs, -> {order created_at: :desc}
  has_many :workbenches
  enumerize :objectid_format, in: %w(netex stif_netex stif_reflex stif_codifligne)
  validates_presence_of :objectid_format

  def add_member(organisation, options = {})
    attributes = options.merge organisation: organisation
    stop_area_referential_memberships.build attributes
  end

  def last_sync
    stop_area_referential_syncs.last
  end
end
