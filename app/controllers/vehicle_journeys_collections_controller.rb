class VehicleJourneysCollectionsController < ApplicationController
  respond_to :json
  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route
    end
  end
  alias_method :route, :parent

  def update
    state  = JSON.parse request.raw_post
    ap '-----------------'
    ap state
    ap '-----------------'
  end
end
