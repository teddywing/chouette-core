class AutocompleteStopAreasController < ChouetteController
  respond_to :json, :only => [:index, :children, :parent, :physicals]

  include ReferentialSupport

  def around
    stop_area   = referential.stop_areas.find params[:id]
    @stop_areas = stop_area.around(referential.stop_areas.where(area_type: params[:target_type]), 300)
  end

  protected
  def collection
    scope = referential.stop_areas.where(deleted_at: nil)
    scope = scope.physical if physical_filter?
    if target_type?
      scope = scope.where(area_type: params[:target_type])
      scope = scope.possible_parents if relation_parent?
      scope = scope.possible_parents if relation_children?
    end
    args = [].tap{|arg| 4.times{arg << "%#{params[:q]}%"}}
    @stop_areas = scope.where("unaccent(name) ILIKE unaccent(?) OR unaccent(city_name) ILIKE unaccent(?) OR registration_number ILIKE ? OR objectid ILIKE ?", *args).limit(50)
    @stop_areas
  end

  def target_type?
    params.has_key?( :target_type)
  end

  def relation_parent?
    params[ :relation ] == "parent"
  end

  def relation_children?
    params[ :relation ] == "children"
  end

  def physical_filter?
    params[:filter] == "physical"
  end
end
