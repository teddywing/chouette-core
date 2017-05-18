class TimeTableCombinationsController < ChouetteController
  belongs_to :referential do
    belongs_to :time_table, :parent_class => Chouette::TimeTable
  end

  def new
    @combination = TimeTableCombination.new(source_id: parent.id)
  end

  def create
    @combination = TimeTableCombination.new(params[:time_table_combination].merge(source_id: parent.id))
    @combination.valid? ? perform_combination : render(:new)
  end

  def perform_combination
    begin
      @time_table    = @combination.combine
      flash[:notice] = t('time_table_combinations.success')
      redirect_to referential_time_table_path(referential, @time_table)
    rescue => e
      flash[:notice] = e.message
      flash[:error]  = t('time_table_combinations.failure')
      render :new
    end
  end
end
