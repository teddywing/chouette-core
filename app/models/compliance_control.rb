class ComplianceControl < ActiveRecord::Base
  extend Enumerize
  belongs_to :compliance_control_set
  has_one :compliance_control_block, dependent: :destroy
  accepts_nested_attributes_for :compliance_control_block

  @@default_criticity = :warning
  @@default_code = ""

  enumerize :criticity, in: %i(info warning error), scope: true, default: :info

  validates :criticity, presence: true
  validates :name, presence: true
  validates :code, presence: true
  validates :origin_code, presence: true
  validates :compliance_control_set, presence: true

  def self.policy_class
    ComplianceControlPolicy
  end

  def self.inherited(child)
    child.instance_eval do
      def model_name
        ComplianceControl.model_name
      end
    end
    super
  end

  before_validation(on: :create) do
   self.name ||= self.class.name
   self.code ||= @@default_code
   self.origin_code ||= @@default_code
   self.criticity ||= @@default_criticity
  end

end

# Ensure STI subclasses are loaded
# http://guides.rubyonrails.org/autoloading_and_reloading_constants.html#autoloading-and-sti
require_dependency 'generic_attribute_control/min_max'
