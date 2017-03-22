module ReferentialSupport
  extend ActiveSupport::Concern

  included do
    before_action :switch_referential
    alias_method :current_referential, :referential
    helper_method :current_referential
  end

  def switch_referential
    Apartment::Tenant.switch!(referential.slug)
  end

  def referential
    @referential ||= find_referential
  end

  def find_referential
    organisation_referential = current_organisation.referentials.find_by id: params[:referential_id]
    return organisation_referential if organisation_referential

    current_organisation.workbenches.each do |workbench|
      workbench_referential = workbench.all_referentials.find_by id: params[:referential_id]
      return workbench_referential if workbench_referential
    end

    raise ActiveRecord::RecordNotFound
  end
end



