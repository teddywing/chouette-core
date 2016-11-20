class ReferentialsController < BreadcrumbController

  defaults :resource_class => Referential

  respond_to :html
  respond_to :json, :only => :show
  respond_to :js, :only => :show

  def new
    @referential = Referential.new_from(Referential.find(params[:from])) if params[:from]

    new! do
      @referential.data_format = current_organisation.data_format
      @referential.workbench_id ||= params[:workbench_id]

      if @referential.in_workbench?
        @referential.init_metadatas first_period_begin: Date.today, first_period_end: Date.today.advance(months: 1)
      end
    end
  end

  def show
     resource.switch
     show! do |format|
       format.json {
         render :json => { :lines_count => resource.lines.count,
                :networks_count => resource.networks.count,
                :vehicle_journeys_count => resource.vehicle_journeys.count + resource.vehicle_journey_frequencies.count,
                :time_tables_count => resource.time_tables.count,
                :referential_id => resource.id}
       }
       format.html { build_breadcrumb :show}
     end
  end

  def edit
    edit! do
      if @referential.in_workbench?
        @referential.init_metadatas first_period_begin: Date.today, first_period_end: Date.today.advance(months: 1)
      end
    end
  end

  def destroy
    workbench = referential.workbench_id

    referential.destroy!
    redirect_to workbench_path(workbench), notice: t('notice.referential.deleted')
  end

  def archive
    referential.archive!
    redirect_to workbench_path(referential.workbench_id), notice: t('notice.referential.archived')
  end
  def unarchive
    referential.unarchive!
    redirect_to workbench_path(referential.workbench_id), notice: t('notice.referential.unarchived')
  end

  protected

  alias_method :referential, :resource

  def resource
    @referential ||= current_organisation.referentials.find_by_id(params[:id])
  end

  def collection
    @referentials ||= current_organisation.referentials.order(:name)
  end

  def build_resource
    super.tap do |referential|
      referential.user_id = current_user.id
      referential.user_name = current_user.name
    end
  end

  def create_resource(referential)
    referential.organisation = current_organisation unless referential.created_from
    super
  end

  private
  def referential_params
    params.require(:referential).permit(
      :id,
      :name,
      :slug,
      :prefix,
      :time_zone,
      :upper_corner,
      :lower_corner,
      :organisation_id,
      :projection_type,
      :data_format,
      :archived_at,
      :created_from_id,
      :workbench_id,
      metadatas_attributes: [:id, :first_period_begin, :first_period_end, :lines => []]
    )
  end

end
