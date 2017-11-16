class LineReferential < ActiveRecord::Base
<<<<<<< HEAD
  include ObjectidFormatterSupport
=======
  include ObjectidFormaterSupport
>>>>>>> Create objectid format and integrate it in models. Work in progress. Refs #4941
  extend StifTransportModeEnumerations
  extend Enumerize
  
  has_many :line_referential_memberships
  has_many :organisations, through: :line_referential_memberships
  has_many :lines, class_name: 'Chouette::Line'
  has_many :group_of_lines, class_name: 'Chouette::GroupOfLine'
  has_many :companies, class_name: 'Chouette::Company'
  has_many :networks, class_name: 'Chouette::Network'
  has_many :line_referential_syncs, -> { order created_at: :desc }
  has_many :workbenches
<<<<<<< HEAD
  enumerize :objectid_format, in: %w(netex stif_netex stif_reflex stif_codifligne), default: 'netex'
=======
  enumerize :objectid_format, in: %w(netex stif_netex stif_reflex stif_codifligne)
>>>>>>> Create objectid format and integrate it in models. Work in progress. Refs #4941

  def add_member(organisation, options = {})
    attributes = options.merge organisation: organisation
    line_referential_memberships.build attributes
  end

  validates :name, presence: true
  validates :sync_interval, presence: true
  # need to define precise validation rules
  validates_inclusion_of :sync_interval, :in => 1..30
  validates_presence_of :objectid_format

  def operating_lines
    lines.where(deactivated: false)
  end

  def last_sync
    line_referential_syncs.last
  end
end
