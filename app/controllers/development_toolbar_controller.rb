class DevelopmentToolbarController < ApplicationController
  def update_settings
    return unless Rails.application.config.development_toolbar.present?
    organisation = current_user.organisation
    organisation.features = params[:features].keys.select{|k| params[:features][k] == "true"}
    organisation.save
    current_user.permissions = params[:permissions].keys.select{|k| params[:permissions][k] == "true"}
    current_user.save
    redirect_to request.referrer || "/"
  end
end
