require 'spec_helper'

describe "/lines/index", :type => :view do
  let(:deactivated_line){ nil }
  let(:line_referential) { assign :line_referential, create(:line_referential) }
  let(:current_organisation) { current_user.organisation }
  let(:context) {
     {
       current_organisation: current_organisation,
       line_referential: line_referential
     }
   }
  let(:lines) do
    assign :lines, build_paginated_collection(:line, LineDecorator, line_referential: line_referential, context: context)
  end
  let!(:q) {  assign :q, Ransack::Search.new(Chouette::Line) }

  before :each do
    deactivated_line
    allow(view).to receive(:collection).and_return(lines)
    allow(view).to receive(:current_referential).and_return(line_referential)
    controller.request.path_parameters[:line_referential_id] = line_referential.id
    render
  end

  common_items = ->{
    it { should have_link_for_each_item(lines, "show", -> (line){ view.line_referential_line_path(line_referential, line) }) }
    it { should have_link_for_each_item(lines, "network", -> (line){ view.line_referential_network_path(line_referential, line.network) }) }
    it { should have_link_for_each_item(lines, "company", -> (line){ view.line_referential_company_path(line_referential, line.company) }) }
  }

  common_items.call()
  it { should have_the_right_number_of_links(lines, 3) }

  it "should match the snapshot" do
    expect(rendered).to match_snapshot("lines/index")
  end

  with_permission "lines.change_status" do
    common_items.call()
    it { should have_link_for_each_item(lines, "deactivate", -> (line){ view.deactivate_line_referential_line_path(line_referential, line) }) }
    it { should have_the_right_number_of_links(lines, 4) }
  end

  with_permission "lines.destroy" do
    common_items.call()
    it {
      should have_link_for_each_item(lines, "destroy", {
        href: ->(line){ view.line_referential_line_path(line_referential, line)},
        method: :delete
      })
    }
    it { should have_the_right_number_of_links(lines, 4) }
  end

  context "with a deactivated item" do
    with_permission "lines.change_status" do
      let(:deactivated_line){ create :line, deactivated: true }

      common_items.call()
      it "should display an activate link for the deactivated one" do
        lines.each do |line|
          if line == deactivated_line
            href = view.activate_line_referential_line_path(line_referential, line)
          else
            href = view.deactivate_line_referential_line_path(line_referential, line)
          end
          selector = "tr.#{TableBuilderHelper.item_row_class_name(lines)}-#{line.id} .actions a[href='#{href}']"
          expect(rendered).to have_selector(selector, count: 1)
        end
      end
      it { should have_the_right_number_of_links(lines, 4) }
    end
  end
end
