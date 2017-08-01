module Api
  module V1
    class NetexImportsController < ChouetteController

      def create
        respond_to do | format |
          format.json(&method(:create_models))
        end
      end


      private

      def create_models
        require 'pry'
        binding.pry
        workbench = Workbench.where(id: netex_import_params['workbench_id']).first
        return render json: {errors: {'workbench_id' => 'missing'}}, status: 406 unless workbench

        @referential = Referential.new(name: netex_import_params['name'], organisation_id: workbench.organisation_id, workbench_id: workbench.id)
        @netex_import = NetexImport.new(netex_import_params.merge(referential_id: @referential.id))
        if @netex_import.valid? && @referential.valid?
          @netex_import.save!
          @referential.save!
        else
          render json: {errors: @netex_import.errors.to_h.merge( @referential.errors.to_h )}, status: 406
        end
      end

      def netex_import_params
        params
          .require('netex_import')
          .permit(:file, :name, :referential_id, :workbench_id)
      end
    end
  end
end
