class TimeTableCombinationsController < ChouetteController
  respond_to :js, :only => [:new,:create]

  belongs_to :referential do
    belongs_to :time_table, :parent_class => Chouette::TimeTable
  end

  def new
    @time_table_combination = TimeTableCombination.new(:source_id => parent.id)
  end

  def create
    @time_table_combination = TimeTableCombination.new( params[:time_table_combination].merge( :source_id => parent.id))
    if @time_table_combination.valid?
      begin
        @time_table = @time_table_combination.combine
        flash[:notice] = t('time_table_combinations.success')
      rescue => e
        flash[:error] = t('time_table_combinations.failure')
        render :new
      end
    else
      render :new
    end
  end
end
