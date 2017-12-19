class PurchaseWindowsController < ChouetteController
  include ReferentialSupport
  include RansackDateFilter
  include PolicyChecker
  before_action only: [:index] { set_date_time_params("bounding_dates", Date) }
  defaults :resource_class => Chouette::PurchaseWindow, collection_name: 'purchase_windows', instance_name: 'purchase_window'
  belongs_to :referential

  def index
    index! do
      scope = self.ransack_period_range(scope: @purchase_windows, error_message: t('compliance_check_sets.filters.error_period_filter'), query: :overlapping)
      @q = scope.ransack(params[:q])
      @purchase_windows = decorate_purchase_windows(@q.result.paginate(page: params[:page], per_page: 30))
    end
  end

  def show
    show! do
      @purchase_window = @purchase_window.decorate(context: {
        referential: @referential
      })
    end
  end

  protected

  def create_resource(purchase_window)
    purchase_window.referential = @referential
    super
  end

  private

  def purchase_window_params
    params.require(:purchase_window).permit(:id, :name, :color, :referential_id, periods_attributes: [:id, :begin, :end, :_destroy])
  end

  def decorate_purchase_windows(purchase_windows)
    ModelDecorator.decorate(
      purchase_windows,
      with: PurchaseWindowDecorator,
      context: {
        referential: @referential
        }
      )
  end
end
