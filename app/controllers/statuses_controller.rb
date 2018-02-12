class StatusesController < ChouetteController
  respond_to :json

  def index

    status = {
      status: global_status,
      referentials_blocked: Referential.blocked.count,
      imports_blocked: Import.blocked.count,
      compliance_check_sets_blocked: ComplianceCheckSet.blocked.count
    }
    render json: status.to_json
  end

  private

  def global_status
    blocked_items = Referential.blocked.exists? || Import.blocked.exists? || ComplianceCheckSet.blocked.exists? ? 'ko' : 'ok'
  end
end
