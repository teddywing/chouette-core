# -*- coding: utf-8 -*-

describe "Group of lines", :type => :feature do
  skip 'delete param of view seems to be constantly false' do
    login_user

    let(:line) { create(:line_with_stop_areas, :network => network, :company => company) }

    let(:line_referential) { create :line_referential }
    let(:network) { create(:network) }
    let(:company) { create(:company) }

    let(:group_of_line) { create :group_of_line, line_referential: line_referential }

    describe 'permissions' do
      before do
        group_of_line.lines << line
        allow_any_instance_of(LinePolicy).to receive(:destroy?).and_return permission
        visit path
      end

      context 'on show view' do
        let( :path ){ line_referential_group_of_line_path(line_referential, group_of_line, delete: true) }

        context 'if permissions present → ' do 
          let( :permission ){ true }

          it 'shows the appropriate buttons' do
            expected_url = line_referential_line_path(line.line_referential, line)
            expect( page ).to have_link('Supprimer', href: expected_url)
          end
        end
        context 'if permissions absent → ' do 
          let( :permission ){ false }

          it 'shows the appropriate buttons' do
            expect( page ).not_to have_link('Supprimer')
          end
        end
      end
    end
  end
end
