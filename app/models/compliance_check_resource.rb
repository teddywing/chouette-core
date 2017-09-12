class ComplianceCheckResource < ActiveRecord::Base
  extend Enumerize

  enumerize :status, in: %w[new successful warning failed]
end
