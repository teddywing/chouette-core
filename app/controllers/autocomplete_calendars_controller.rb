class AutocompleteCalendarsController < ApplicationController
  respond_to :json, :only => [:autocomplete]

  def autocomplete
    @calendars = current_organisation.referentials.search(params[:q]).result.paginate(page: params[:page])
  end
end
