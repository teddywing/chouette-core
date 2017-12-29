RSpec.describe '/imports/show', type: :view do
  let(:workbench){ create :workbench }
  let(:workbench_import){ create :workbench_import, workbench: workbench }
  let!( :messages ) {[
    create(:corrupt_zip_file, import: workbench_import),
    create(:inconsistent_zip_file, import: workbench_import),
  ]}


  before do
    assign :import, workbench_import.decorate( context: {workbench: workbench} )
    render
  end

  it 'shows the correct record...' do
    # ... zip file name
    expect(rendered).to have_selector('.dl-def') do
      with_text workbench_import.file
    end

    # ... messages
    messages.each do | message |
      # require 'htmlbeautifier'
      # b = HtmlBeautifier.beautify(rendered, indent: '  ')
      expect(rendered).to have_selector('dl#import_messages dt.import_message') do
        with_text message.criticity
      end
      expect(rendered).to have_selector('dl#import_messages dd.import_message') do
        with_text rendered_message( message )
      end
    end
  end

  def rendered_message message
    return I18n.t message.message_key, message.message_attributes.symbolize_keys
  end

end
