class Api::V1::ImportsController < Api::V1::IbooController
  defaults :resource_class => WorkbenchImport
  belongs_to :workbench

  def create
    binding.pry
    args    = workbench_import_params.merge(creator: 'Webservice')
    binding.pry
    @import = parent.workbench_imports.create(args)
    binding.pry
    create!
  end

  private
  def workbench_import_params
    params.require(:workbench_import).permit(:file, :name)
  end
end
