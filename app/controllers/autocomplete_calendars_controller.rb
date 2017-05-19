class AutocompleteCalendarsController < ApplicationController
  respond_to :json, :only => [:autocomplete]

  def autocomplete
    @calendars = Calendar.search(params[:q]).result.paginate(page: params[:page])
  end
end
