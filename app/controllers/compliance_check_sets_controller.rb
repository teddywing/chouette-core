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

  def show
    show!(&method(:implement_show))
  end


  private

  # Action Implementation
  # ---------------------
  def implement_show format
    format.html(&method(:implement_html_show))
  end

  def implement_html_show _mime_response
    @q_checks_form        = @compliance_check_set.compliance_checks.ransack(params[:q])
    @compliance_check_set = @compliance_check_set.decorate
    @compliance_checks    =
      decorate_compliance_checks( @q_checks_form.result)
        .group_by(&:compliance_check_block)
    @direct_compliance_checks = @compliance_checks.delete nil
  end

  # Decoration
  # ----------
  def decorate_compliance_checks(compliance_checks)
    ModelDecorator.decorate(
      compliance_checks,
      with: ComplianceCheckDecorator)
  end
end
