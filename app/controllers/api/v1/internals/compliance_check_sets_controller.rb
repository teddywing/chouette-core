module Api
  module V1
    module Internals
      class ComplianceCheckSetsController < ApplicationController
        include ControlFlow

        def validated
          find_compliance_check_set

          if @compliance_check_set.update_status
            render :validated
          else
            render json: {
              status: "error",
              messages: @compliance_check_set.errors.full_messages
            }
          end
        end

        def notify_parent
          find_compliance_check_set
          if  @compliance_check_set.notify_parent && @compliance_check_set.parent
            render json: {
              status: "ok",
              message:"#{@compliance_check_set.parent_type} (id: #{@compliance_check_set.parent_id}) successfully notified at #{l(@compliance_check_set.notified_parent_at)}"
            }
          else
            render json: {status: "error", message: @compliance_check_set.errors.full_messages }
          end         
        end

        private

        def find_compliance_check_set
          @compliance_check_set = ComplianceCheckSet.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: {
            status: "error", 
            message: "Record not found"
          }
          finish_action!   
        end
      end
    end
  end
end  
