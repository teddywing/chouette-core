class LineReferentialMembership < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :line_referential
end
