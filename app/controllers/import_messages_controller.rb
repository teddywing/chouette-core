class ImportMessagesController < BreadcrumbController
  defaults resource_class: ImportMessage, collection_name: 'import_messages', instance_name: 'import_message'
  respond_to :csv
  belongs_to :import, :parent_class => Import do
    belongs_to :import_resource, :parent_class => ImportResource
  end


  def index
    index! do |format|
      format.csv {
        send_data ImportMessageExport.new(:import_messages => @import_messages).to_csv(:col_sep => ";") , :filename => "test.csv"
      }
    end
  end

  protected
  def collection
    @import_messages ||= parent.messages
  end

  def parent
    @import_resource ||= ImportResource.find(params[:import_resource_id])
  end

end
