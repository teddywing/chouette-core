# Check availability of optional features
#
# In your controller, use :
#
#   requires_feature :test
#   requires_feature :test, only: [:show]
#
# In your view, use :
#
#   has_feature? :test
#
module FeatureChecker
  extend ActiveSupport::Concern

  module ClassMethods
    def requires_feature(feature, options = {})
      before_action options do
        check_feature! feature
      end
    end
  end

  included do
    helper_method :has_feature?
  end

  protected

  def has_feature?(*features)
    features.all? do |feature|
      current_organisation.has_feature? feature
    end
  end

  def check_feature!(*features)
    authorized = has_feature? *features
    raise NotAuthorizedError, "Feature not autorized" unless authorized
  end

  class NotAuthorizedError < StandardError; end
end
