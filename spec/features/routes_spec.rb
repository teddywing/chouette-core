# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Routes", :type => :feature do
  login_user

  let!(:line) { create(:line) }
  let!(:route) { create(:route, :line => line) }
  let!(:route2) { create(:route, :line => line) }
  #let!(:stop_areas) { Array.new(4) { create(:stop_area) } }
  let!(:stop_points) { Array.new(4) { create(:stop_point, :route => route) } }

  describe "from lines page to a line page" do
    it "display line's routes" do
      visit referential_lines_path(referential)
      first(:link, 'Voir').click
      expect(page).to have_content(route.name)
      expect(page).to have_content(route2.name)
    end
  end

  describe "from line's page to route's page" do
    it "display route properties" do
      visit referential_line_path(referential,line)
      click_link "#{route.name}"
      expect(page).to have_content(route.name)
      expect(page).to have_content(route.number)
    end
  end

  describe "from line's page, create a new route" do
    it "return to line's page that display new route" do
      visit referential_line_path(referential,line)
      click_link "Ajouter un itinéraire"
      fill_in "route_name", :with => "A to B"
      # select 'Aller', :from => "route_direction"
      select 'Aller', :from => "route_wayback"
      click_button("Créer un itinéraire")
      expect(page).to have_content("A to B")
    end
  end

  describe "Modifies boarding/alighting properties on route stops" do
    xit "Puts (http) an update request" do
      #visit edit_boarding_alighting_referential_line_route_path(referential, line, route)
      visit referential_line_route_path(referential, line, route)
      click_link I18n.t('routes.actions.edit_boarding_alighting')
      #select('', :from => '')
      # Changes the boarding of the first stop
      # Changes the alighting of the last stop
      # save
      #click_button(I18n.t('helpers.submit.update', model: I18n.t('activerecord.models.route.one')))
      click_button(I18n.t('helpers.submit.update', model: I18n.t('activerecord.models.route.one')))
    end
  end

end
