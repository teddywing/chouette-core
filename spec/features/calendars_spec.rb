# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Calendars', type: :feature do
  login_user

  let!(:calendars) { Array.new(2) { create :calendar, organisation_id: 1 } }

  describe 'index' do
    before(:each) { visit calendars_path }

    it 'displays calendars' do
      expect(page).to have_content(calendars.first.short_name)
      expect(page).to have_content(calendars.last.short_name)
    end

    context 'filtering' do
      it 'supports filtering by short name' do
        fill_in 'q[short_name_cont]', with: calendars.first.short_name
        click_button 'search-btn'
        expect(page).to have_content(calendars.first.short_name)
        expect(page).not_to have_content(calendars.last.short_name)
      end

      it 'supports filtering by shared' do
        shared_calendar = create :calendar, organisation_id: 1, shared: true
        visit calendars_path
        select I18n.t('calendars.index.shared'), from: 'q[shared_eq]'
        click_button 'search-btn'
        expect(page).to have_content(shared_calendar.short_name)
        expect(page).not_to have_content(calendars.first.short_name)
      end

      it 'supports filtering by date' do
        july_calendar = create :calendar, dates: [Date.new(2017, 7, 7)], date_ranges: [Date.new(2017, 7, 15)..Date.new(2017, 7, 30)], organisation_id: 1
        visit calendars_path
        fill_in 'q_contains_date', with: '2017/07/07'
        click_button 'search-btn'
        expect(page).to have_content(july_calendar.short_name)
        expect(page).not_to have_content(calendars.first.short_name)
        fill_in 'q_contains_date', with: '2017/07/18'
        click_button 'search-btn'
        expect(page).to have_content(july_calendar.short_name)
        expect(page).not_to have_content(calendars.first.short_name)
      end
    end
  end

  describe 'show' do
    it 'displays calendar' do
      visit calendar_path(calendars.first)
      expect(page).to have_content(calendars.first.name)
    end
  end
end

