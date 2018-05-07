class Workgroup < ApplicationModel
  belongs_to :line_referential
  belongs_to :stop_area_referential
  belongs_to :owner, class_name: "Organisation"

  has_many :workbenches
  has_many :calendars
  has_many :organisations, through: :workbenches
  has_many :referentials, through: :workbenches

  validates_uniqueness_of :name

  validates_presence_of :line_referential_id
  validates_presence_of :stop_area_referential_id
  validates_uniqueness_of :stop_area_referential_id
  validates_uniqueness_of :line_referential_id

  has_many :custom_fields

  accepts_nested_attributes_for :workbenches

  def custom_fields_definitions
    Hash[*custom_fields.map{|cf| [cf.code, cf]}.flatten]
  end

  def has_export? export_name
    export_types.include? export_name
  end

  def available_compliance_control_sets
    %i(
      import
      merge
      automatic
      workgroup
      workbench
    ).inject({}) do |h, k|
      h[k] = "workgroups.available_compliance_control_sets.#{k}".t.capitalize
      h
    end
  end

  # XXX
  # def import_compliance_control_sets
  #   @import_compliance_control_sets ||= import_compliance_control_set_ids.map{|id| ComplianceControlSet.find(id)}
  # end
end
