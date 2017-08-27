module Api
  module V1
    class NetexImportsController < ChouetteController
      include ControlFlow

      skip_before_action :authenticate

      def create
        respond_to do | format |
          format.json(&method(:create_models))
        end
      end


      private

      def find_workbench
        @workbench = Workbench.find(netex_import_params['workbench_id'])
      rescue ActiveRecord::RecordNotFound
        render json: {errors: {'workbench_id' => 'missing'}}, status: 406
        finish_action!
      end

      def create_models
        find_workbench
        create_referential
        create_netex_import
      end

      def create_netex_import
        @netex_import = NetexImport.new(netex_import_params.merge(referential_id: @new_referential.id))
        @netex_import.save!
      rescue ActiveRecord::RecordInvalid
        render json: {errors: @netex_import.errors}, status: 406
        finish_action!
      end

      def create_referential
        @new_referential =
          Referential.new(
            name: netex_import_params['name'],
            organisation_id: @workbench.organisation_id,
            workbench_id: @workbench.id)
        @new_referential.save!
        #  TODO: >>> REMOVE ME !!!!
        ReferentialMetadataKludge.make_metadata_from_name! netex_import_params['name'], referential_id: @new_referential.id
        #  <<< REMOVE ME !!!!
      rescue ActiveRecord::RecordInvalid
        # render json: {errors: @new_referential.errors}, status: 406
        render json: {errors: ErrorFormat.details(@new_referential)}, status: 406
        finish_action!
      end

      def netex_import_params
        params
          .require('netex_import')
          .permit(:file, :name, :workbench_id)
      end
    end
  end
end
