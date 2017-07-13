class LineFootnotesController < ChouetteController
  defaults resource_class: Chouette::Line, collection_name: 'lines', instance_name: 'line'
  belongs_to :referential

  def edit
    edit! do
      build_breadcrumb :edit
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to referential_line_footnotes_path(@referential, @line) , notice: t('notice.footnotes.updated') }
      failure.html { render :edit }
    end
  end

  protected

  alias_method :line, :resource

  # overrides default
  def check_policy
    authorize resource, "#{action_name}_footnote?".to_sym
  end

  def resource
    @line ||= current_referential.lines.find params[:line_id]
  end

  private

  def line_params
    params.require(:line).permit(
      { footnotes_attributes: [ :code, :label, :_destroy, :id ] } )
  end
end
