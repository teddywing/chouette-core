module ComplianceItemSupport
  extend ActiveSupport::Concern
  included do

  end

  module ClassMethods
    def dynamic_attributes
      stored_attributes[:control_attributes] || []
    end
  end

  def prerequisite; I18n.t('compliance_controls.metas.no_prerequisite'); end

end
