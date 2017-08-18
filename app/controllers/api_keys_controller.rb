class ApiKeysController < BreadcrumbController
  defaults resource_class: Api::V1::ApiKey

  def create
    @api_key = Api::V1::ApiKey.new(api_key_params.merge(organisation: current_organisation))
    create! { organisation_api_key_path(resource) }
  end

  def index
    @api_keys = decorate_api_keys(current_organisation.api_keys.paginate(page: params[:page]))
  end

  def update
    update! { organisation_api_key_path(resource) }
  end

  def destroy
    destroy! { organisation_api_keys_path }
  end

  private
  def api_key_params
    params.require(:api_key).permit(:name, :referential_id)
  end

  def decorate_api_keys(api_keys)
    ModelDecorator.decorate(
      api_keys,
      with: ApiKeyDecorator,
    )
  end
end
