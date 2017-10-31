class ComplianceCheckSetsController < InheritedResources::Base
  defaults resource_class: ComplianceCheckSet
  include RansackDateFilter
  before_action only: [:index] { set_date_time_params("created_at", DateTime) }
  respond_to :html

  belongs_to :workbench

  def index
    index! do |format|
      scope = self.ransack_period_range(scope: @compliance_check_sets, error_message: t('compliance_check_sets.filters.error_period_filter'), query: :where_created_at_between)
      @q_for_form = scope.ransack(params[:q])
      format.html {
        @compliance_check_sets = ModelDecorator.decorate(
          @q_for_form.result,
          with: ComplianceCheckSetDecorator
        )
      }
    end
  end
end
