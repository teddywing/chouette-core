# -*- coding: utf-8 -*-

describe "Referentials", :type => :feature do

  login_user
  let(:referential) { Referential.first }

  let( :edit_link_text ){ I18n.t('actions.edit') }
  let( :destroy_link_text ){ I18n.t('actions.destroy') }


  context 'permissions' do
    before do
      allow_any_instance_of(ReferentialPolicy).to receive(:organisation_match?).and_return organisation_match
      visit path
    end

    context 'on show view with common lines' do
      let( :path ){ referential_path(referential) }
      before do
        allow_any_instance_of(ReferentialPolicy).to receive(:common_lines?).and_return common_lines
      end

      context 'if organisations match →' do
        let( :organisation_match ){ true }
        let( :common_lines ){ false }

        it 'shows the edit button' do
          expected_href = edit_referential_path(referential)
          expect( page ).to have_link(edit_link_text, href: expected_href)
        end
        it 'shows the delete button' do
          expected_href = referential_path(referential)
          expect( page ).to have_css(%{a[href=#{expected_href.inspect}]}, text: destroy_link_text)
        end
      end

      context 'if organisations do not match →' do
        let( :organisation_match ){ false }
        let( :common_lines ){ true }

        it 'does not show the delete button' do
          expected_href = edit_referential_path(referential)
          expect( page ).not_to have_link(edit_link_text, href: expected_href)
        end
        it 'does not show the delete button' do
          expected_href = referential_path(referential)
          expect( page ).not_to have_css(%{a[href=#{expected_href.inspect}] span}, text: destroy_link_text)
        end
      end
    end

  end
end
