module Api
  module V1
    class NetexImportsController < ChouetteController

      def create
        respond_to do | format |
          format.json do 
            workbench = Workbench.where(id: netex_import_params['workbench_id']).first
            if workbench
              @referential = Referential.new(name: netex_import_params['name'], organisation_id: workbench.organisation_id, workbench_id: workbench.id)
              @import = NetexImport.new(netex_import_params)
              if @import.valid? && @referential.valid?
                @import.save!
                @referential.save!
              else
                render json: {errors: @import.errors.to_h.merge( @referential.errors.to_h )}, status: 406
              end
            else
              render json: {errors: {'workbench_id' => 'missing'}}, status: 406
            end
          end
        end
      end


      private

      def netex_import_params
        params
          .require('netex_import')
          .permit(:file, :name, :referential_id, :workbench_id)
      end
    end
  end
end
