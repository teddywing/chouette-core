module WorkgroupSupport
  extend ActiveSupport::Concern

  included do
    before_action :find_workgroup
  end

  def find_workgroup
   @workgroup ||= Workgroup.find params[:workgroup_id]
  end

end
