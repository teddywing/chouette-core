class StopAreaReferential < ActiveRecord::Base
  has_many :stop_area_referential_memberships
  has_many :organisations, through: :stop_area_referential_memberships

  def add_member(organisation, options = {})
    attributes = options.merge organisation: organisation
    stop_area_referential_memberships.build attributes
  end

end
