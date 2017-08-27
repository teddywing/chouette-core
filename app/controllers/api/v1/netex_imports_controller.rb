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
        attributes = netex_import_params
        if @new_referential.persisted?
          attributes = attributes.merge referential_id: @new_referential.id, creator: "Webservice"
        else
          attributes = attributes.merge status: "failed"
        end

        @netex_import = NetexImport.new attributes
        @netex_import.save!

        unless @netex_import.referential
          @netex_import.messages.create criticity: :error, message_key: "cant_create_referential"
        end
      rescue ActiveRecord::RecordInvalid
        render json: {errors: @netex_import.errors}, status: 406
        finish_action!
      end

      def create_referential
        #  TODO: >>> REMOVE ME !!!!
        metadata = ReferentialMetadataKludge.make_metadata_from_name! netex_import_params['name']
        #  <<< REMOVE ME !!!!

        @new_referential =
          Referential.new(
            name: netex_import_params['name'],
            organisation_id: @workbench.organisation_id,
            workbench_id: @workbench.id,
            metadatas: [metadata]
          )
        @new_referential.save
      end

      def netex_import_params
        params
          .require('netex_import')
          .permit(:file, :name, :workbench_id, :parent_id, :parent_type)
      end
    end
  end
end
