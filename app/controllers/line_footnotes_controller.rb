class LineFootnotesController < ChouetteController
  before_action :set_line
  before_action :check_policy, :only => [:edit, :update]

  def show
  end

  def edit
  end

  def update
    if @line.update(line_params)
      redirect_to referential_line_path(@referential, @line) , notice: t('notice.footnotes.updated')
    else
      render :edit
    end
  end

  private
  def check_policy
    authorize @line, :update_footnote?
  end

  def set_line
    @referential = Referential.find params[:referential_id]
    @line = @referential.lines.find params[:line_id]
  end

  def line_params
    params.require(:line).permit(
      { footnotes_attributes: [ :code, :label, :_destroy, :id ] } )
  end
end
