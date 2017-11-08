class ComplianceCheckBlock < ActiveRecord::Base
  belongs_to :compliance_check_set

  has_many :compliance_checks

  hstore_accessor :condition_attributes,
    transport_mode: :string,
    transport_submode: :string

end
