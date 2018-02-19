class ApiKeysController < ChouetteController
  defaults resource_class: Api::V1::ApiKey
  include PolicyChecker

  def create
    @api_key = Api::V1::ApiKey.new(api_key_params.merge(organisation: current_organisation))
    create! do |format|
      format.html {
        redirect_to dashboard_path
      }
    end
  end

  def update
    update! do |format|
      format.html {
        redirect_to dashboard_path
      }
    end
  end

  def destroy
    destroy! do |format|
      format.html {
        redirect_to dashboard_path
      }
    end
  end

  private
  def api_key_params
    params.require(:api_key).permit(:name, :referential_id)
  end
end
