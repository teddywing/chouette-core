class ImportResourcesController < BreadcrumbController
  defaults resource_class: ImportResource, collection_name: 'import_resources', instance_name: 'import_resource'
  respond_to :html
  belongs_to :import

  def index
    index! do |format|
      format.html {
        @import_resources = decorate_import_resources(@import_resources)
      }
    end
  end

  def download
    if params[:token] == resource.token_download
      send_file resource.file.path
    else
      user_not_authorized
    end
  end

  protected
  def collection
    @import_resources ||= parent.resources
  end

  private

  def decorate_import_resources(import_resources)
    ImportResourcesDecorator.decorate(
      import_resources,
      with: ImportResourceDecorator,
      context: {
        import: @import
      }
    )
  end
end
