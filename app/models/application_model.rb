class ApplicationModel < ::ActiveRecord::Base
  include MetadataSupport

  self.abstract_class = true
end
