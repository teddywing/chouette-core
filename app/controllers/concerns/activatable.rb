module Activatable
  extend ActiveSupport::Concern

  %w(activate deactivate).each do |action|
    define_method action do
      authorize resource, "#{action}?"
      resource.send "#{action}!"
      redirect_to request.referer || [current_referential, resource]
    end
  end
end
