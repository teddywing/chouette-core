class DevelopmentToolbarController < ApplicationController
  def update_settings
    return unless Rails.application.config.development_toolbar.present?
    organisation = current_user.organisation
    organisation.features = params[:features].keys.select{|k| params[:features][k] == "true"}
    organisation.save
    current_user.permissions = params[:permissions].keys.select{|k| params[:permissions][k] == "true"}
    current_user.save
    if params[:export_types].present?
      params[:export_types].each do |workgroup_id, export_types|
        workgroup = Workgroup.find workgroup_id
        workgroup.export_types = export_types.keys.select{|k| export_types[k] == "true"}
        workgroup.save!
      end
    end
    redirect_to request.referrer || "/"
  end
end
