class Api::V1::ImportsController < Api::V1::IbooController
  defaults :resource_class => WorkbenchImport
  belongs_to :workbench

  def create
    args    = workbench_import_params.merge(creator: 'Webservice')
    @import = parent.workbench_imports.create(args)
    if @import.valid? 
      create!
    else
      binding.pry
      render json: { status: "error", messages: @import.errors.full_messages }
    end
  end

  private
  def workbench_import_params
    params.require(:workbench_import).permit(:file, :name)
  end
end
