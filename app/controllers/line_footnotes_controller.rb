class LineFootnotesController < BreadcrumbController
  defaults :resource_class => Chouette::Line
  include PolicyChecker
  before_action :check_policy, only: [:edit, :update, :destroy]
  respond_to :json, :only => :show
  belongs_to :referential

  def show
    show! do
      build_breadcrumb :show
    end
    @footnotes = @line.footnotes
  end

  def edit
    edit! do
      build_breadcrumb :edit
    end
  end

  def update
    if @line.update(line_params)
      redirect_to referential_line_footnotes_path(@referential, @line) , notice: t('notice.footnotes.updated')
    else
      render :edit
    end
  end

  protected

  # overrides default
  def check_policy
    authorize resource, "#{action_name}_footnote?".to_sym
  end

  private
  def resource
    @referential = Referential.find params[:referential_id]
    @line = @referential.lines.find params[:line_id]
  end

  def line_params
    params.require(:line).permit(
      { footnotes_attributes: [ :code, :label, :_destroy, :id ] } )
  end
end
