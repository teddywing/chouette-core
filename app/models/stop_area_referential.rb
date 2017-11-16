class StopAreaReferential < ActiveRecord::Base
  extend Enumerize
<<<<<<< HEAD
  include ObjectidFormatterSupport
=======
  include ObjectidFormaterSupport
>>>>>>> Create objectid format and integrate it in models. Work in progress. Refs #4941
  has_many :stop_area_referential_memberships
  has_many :organisations, through: :stop_area_referential_memberships

  has_many :stop_areas, class_name: 'Chouette::StopArea'
  has_many :stop_area_referential_syncs, -> {order created_at: :desc}
  has_many :workbenches
<<<<<<< HEAD
  enumerize :objectid_format, in: %w(netex stif_netex stif_reflex stif_codifligne), default: 'netex'
=======
  enumerize :objectid_format, in: %w(netex stif_netex stif_reflex stif_codifligne)
>>>>>>> Create objectid format and integrate it in models. Work in progress. Refs #4941
  validates_presence_of :objectid_format

  def add_member(organisation, options = {})
    attributes = options.merge organisation: organisation
    stop_area_referential_memberships.build attributes
  end

  def last_sync
    stop_area_referential_syncs.last
  end
end
