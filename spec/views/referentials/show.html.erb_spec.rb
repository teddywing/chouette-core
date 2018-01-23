require 'spec_helper'

describe "referentials/show", type: :view do
  let!(:referential) do
    referential = create(:referential, organisation: organisation)
    assign :referential, referential.decorate(context: {
      current_organisation: referential.organisation
    })
  end
  let(:permissions){ [] }
  let(:current_organisation) { organisation }
  let(:current_offer_workbench) { create :workbench, organisation: organisation}
  let(:current_workgroup) { current_offer_workbench.workgroup }
  let(:readonly){ false }

  before :each do
    assign :reflines, []
    allow(view).to receive(:current_offer_workbench).and_return(current_offer_workbench)
    allow(view).to receive(:current_organisation).and_return(current_organisation)
    allow(view).to receive(:current_workgroup).and_return(current_workgroup)
    allow(view).to receive(:current_user).and_return(current_user)

    allow(view).to receive(:resource).and_return(referential)
    allow(view).to receive(:has_feature?).and_return(true)
    allow(view).to receive(:user_signed_in?).and_return true
    controller.request.path_parameters[:id] = referential.id
    allow(view).to receive(:params).and_return({action: :show})

    allow(referential).to receive(:referential_read_only?){ readonly }
  end
  it "should not present edit button" do
    expect(rendered).to_not have_selector("a[href=\"#{view.edit_referential_path(referential)}\"]")
  end

  with_permission "referentials.update" do
    it "should present edit button" do
      expect(rendered).to have_selector("a[href=\"#{view.edit_referential_path(referential)}\"]")
    end

    context "with a readonly referential" do
      let(:readonly){ true }
      it "should not present edit button" do
        expect(rendered).to_not have_selector("a[href=\"#{view.edit_referential_path(referential)}\"]")
      end
    end
  end

  describe "action links" do
    set_invariant "referential.object.full_name", "referential_full_name"
    set_invariant "referential.object.updated_at", "01/01/2000 00:00".to_time
    set_invariant "referential.object.id", "99"

    before(:each){
      render template: "referentials/show", layout: "layouts/application"
    }
    context "with a readonly referential" do
      let(:readonly){ true }
      it { should match_actions_links_snapshot "referentials/show_readonly" }

      %w(create destroy update).each do |p|
        with_permission "referentials.#{p}" do
          it { should match_actions_links_snapshot "referentials/show_readonly_#{p}" }
        end
      end
    end

    context "with a non-readonly referential" do
      it { should match_actions_links_snapshot "referentials/show" }

      %w(create destroy update).each do |p|
        with_permission "referentials.#{p}" do
          it { should match_actions_links_snapshot "referentials/show_#{p}" }
        end
      end
    end

    %w(purchase_windows referential_vehicle_journeys).each do |f|
      with_feature f do
        it { should match_actions_links_snapshot "referentials/show_#{f}" }

        %w(create update destroy).each do |p|
          with_permission "referentials.#{p}" do
            it { should match_actions_links_snapshot "referentials/show_#{f}_#{p}" }
          end
        end
      end
    end
  end
end
