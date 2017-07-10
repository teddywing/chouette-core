class AutocompleteCalendarsController < ApplicationController
  respond_to :json, :only => [:autocomplete]

  def autocomplete
    scope = Calendar.where('organisation_id = ? OR shared = true', current_organisation.id)
    @calendars = scope.search(params[:q]).result.paginate(page: params[:page])
  end
end
