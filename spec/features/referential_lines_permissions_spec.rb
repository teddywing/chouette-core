# -*- coding: utf-8 -*-

describe 'ReferentialLines', type: :feature do
  login_user
  let!(:referential_metadata) { create :referential_metadata, referential: referential }
  let( :line ){ referential.lines.first }

  context 'permissions' do 
    before do
      allow_any_instance_of(RoutePolicy).to receive(:create?).and_return permission
      visit path
    end
    
    context 'on show view' do 
      let( :path ){ referential_line_path(referential, line) }

      context 'if present → ' do 
        let( :permission ){ true }
        it 'shows the corresponding button' do
          expected_href = new_referential_line_route_path(referential, line)
          expect( page ).to have_link("Ajouter un itinéraire", href: expected_href)
        end
      end
      context 'if absent → ' do 
        let( :permission ){ false }
        it 'does not show the corresponding button' do
          expect( page ).not_to have_link("Ajouter un itinéraire")
        end
      end
    end
    
  end

  # describe 'show' do
  #   it 'displays referential line' do
  #     visit referential_line_path(referential, referential.lines.first)
  #     expect(page).to have_content(referential.lines.first.name)
  #   end
  #   it 'displays referential line' do
  #     visit referential_line_path(referential, referential.lines.first, sort: "stop_points")
  #     expect(page).to have_content(referential.lines.first.name)
  #   end
  # end
end
