class ExportsController < ChouetteController
  include PolicyChecker
  include RansackDateFilter
  include IevInterfaces
  skip_before_action :authenticate_user!, only: [:upload]
  defaults resource_class: Export::Base, collection_name: 'exports', instance_name: 'export'

  def upload
    if params[:token] == resource.token_download
      send_file resource.file.path
    else
      user_not_authorized
    end
  end

  private

  def build_resource
    @export ||= Export::Workbench.new(*resource_params) do |export|
      export.workbench = parent
      export.creator   = current_user.name
    end
  end

  def export_params
    params.require(:export).permit(
      :name,
      :type,
      :referential_id
    )
  end

  def decorate_collection(exports)
    ExportDecorator.decorate(
      exports,
      context: {
        workbench: @workbench
      }
    )
  end
end
