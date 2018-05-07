class ImportMessagesController < ChouetteController
  defaults resource_class: Import::Message, collection_name: 'import_messages', instance_name: 'import_message'
  respond_to :csv
  belongs_to :import, :parent_class => Import::Base do
    belongs_to :import_resource, :parent_class => Import::Resource
  end


  def index
    index! do |format|
      format.csv {
        send_data Import::MessageExport.new(:import_messages => @import_messages).to_csv(:col_sep => "\;", :quote_char=>'"', force_quotes: true) , :filename => "#{t('import_messages.import_errors_')}_#{line_code}_#{Date.today.to_s}.csv"
      }
    end
  end

  protected
  def collection
    @import_messages ||= parent.messages
  end

  def parent
    @import_resource ||= Import::Resource.find(params[:import_resource_id])
  end

  private

  def line_code
    Chouette::Line.find_by_objectid("#{@import_resource.reference}").get_objectid.local_id
  end

end
