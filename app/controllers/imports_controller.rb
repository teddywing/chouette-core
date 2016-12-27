class ImportsController < ChouetteController
  defaults :resource_class => Import
  respond_to :html
  belongs_to :referential

  def show
    show! do
      build_breadcrumb :show
    end
  end

  def index
    index! do
      build_breadcrumb :index
    end
  end

  def new
  end
end
