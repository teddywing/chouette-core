# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'ReferentialStopAreas', type: :feature do
  login_user

  let(:referential) { Referential.first }
  let(:stop_area_referential) { referential.stop_area_referential }
  let!(:stop_areas) { Array.new(2) { create :stop_area, stop_area_referential: stop_area_referential } }

  describe 'index' do
    before(:each) { visit referential_stop_areas_path(referential) }

    it 'displays referential stop_areas' do
      expect(page).to have_content(stop_areas.first.name)
      expect(page).to have_content(stop_areas.last.name)
    end

    context 'filtering' do
      it 'supports filtering by name' do
        fill_in 'q[name_or_objectid_cont]', with: stop_areas.first.name
        click_button 'search-btn'
        expect(page).to have_content(stop_areas.first.name)
        expect(page).not_to have_content(stop_areas.last.name)
      end

      it 'supports filtering by objectid' do
        fill_in 'q[name_or_objectid_cont]', with: stop_areas.first.objectid
        click_button 'search-btn'
        expect(page).to have_content(stop_areas.first.name)
        expect(page).not_to have_content(stop_areas.last.name)
      end
    end
  end

  describe 'show' do
    it 'displays referential stop area' do
      visit referential_stop_area_path(referential, stop_areas.first)
      expect(page).to have_content(stop_areas.first.name)
    end
  end
end
