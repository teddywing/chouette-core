require 'spec_helper'

describe "workbenches/show", :type => :view do
  let!(:ids) { ['STIF:CODIFLIGNE:Line:C00840', 'STIF:CODIFLIGNE:Line:C00086'] }
  let!(:lines) {
    ids.map do |id|
      create :line, objectid: id, line_referential: workbench.line_referential
    end
  }
  let!(:workbench){ assign :workbench, create(:workbench) }
  let!(:same_organisation_referential){ create :workbench_referential, workbench: workbench, metadatas: [create(:referential_metadata, lines: lines)] }
  let!(:different_organisation_referential){ create :workbench_referential, metadatas: [create(:referential_metadata, lines: lines)] }
  let!(:referentials){
    same_organisation_referential && different_organisation_referential
    assign :wbench_refs, paginate_collection(Referential, ReferentialDecorator)
  }
  let!(:q) { assign :q_for_form, Ransack::Search.new(Referential) }
  before :each do
    lines
    controller.request.path_parameters[:id] = workbench.id
    expect(workbench.referentials).to include same_organisation_referential
    expect(workbench.referentials).to_not include different_organisation_referential
    expect(workbench.all_referentials).to include same_organisation_referential
    expect(workbench.all_referentials).to include different_organisation_referential
    render
  end

  it { should have_link_for_each_item(referentials, "show", -> (referential){ view.referential_path(referential) }) }
  it "should enable the checkbox for the referential which belongs to the same organisation" do
    klass = "#{TableBuilderHelper.item_row_class_name(referentials)}-#{same_organisation_referential.id}"
    selector = "tr.#{klass} [type=checkbox][value='#{same_organisation_referential.id}']:not([disabled])"
    expect(rendered).to have_selector(selector, count: 1)
  end

  it "should disable the checkbox for the referential which does not belong to the same organisation" do
    klass = "#{TableBuilderHelper.item_row_class_name(referentials)}-#{different_organisation_referential.id}"
    selector = "tr.#{klass} [type=checkbox][disabled][value='#{different_organisation_referential.id}']"
    expect(rendered).to have_selector(selector, count: 1)
  end
end
