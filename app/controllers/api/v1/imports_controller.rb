class Api::V1::ImportsController < Api::V1::IbooController
  defaults :resource_class => Api::V1::ApiKey
  belongs_to :workbench
end
