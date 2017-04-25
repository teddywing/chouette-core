# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Calendars', type: :feature do
  login_user

  let!(:calendars) { Array.new(2) { create :calendar, organisation_id: 1 } }
  let!(:shared_calendar_other_org) { create :calendar, shared: true }
  let!(:unshared_calendar_other_org) { create :calendar }

  describe 'index' do
    before(:each) { visit calendars_path }

    it 'displays calendars of the current organisation and shared calendars' do
      expect(page).to have_content(calendars.first.short_name)
      expect(page).to have_content(shared_calendar_other_org.short_name)
      expect(page).not_to have_content(unshared_calendar_other_org.short_name)
    end

    context 'filtering' do
      # Fixme !
      # it 'supports filtering by short name' do
      #   fill_in 'q[short_name_cont]', with: calendars.first.short_name
      #   click_button 'search_btn'
      #   expect(page).to have_content(calendars.first.short_name)
      #   expect(page).not_to have_content(calendars.last.short_name)
      # end

      # it 'supports filtering by shared' do
      #   shared_calendar = create :calendar, organisation_id: 1, shared: true
      #   visit calendars_path
      #   # select I18n.t('true'), from: 'q[shared]'
      #   find(:css, '#q_shared').set(true)
      #   click_button 'filter_btn'
      #   expect(page).to have_content(shared_calendar.short_name)
      #   expect(page).not_to have_content(calendars.first.short_name)
      # end

      # wip
      # it 'supports filtering by date' do
      #   july_calendar = create :calendar, dates: [Date.new(2017, 7, 7)], date_ranges: [Date.new(2017, 7, 15)..Date.new(2017, 7, 30)], organisation_id: 1
      #   visit calendars_path
      #   select '7', from: 'q_contains_date_3i'
      #   select 'juillet', from: 'q_contains_date_2i'
      #   select '2017', from: 'q_contains_date_1i'
      #   click_button 'filter_btn'
      #   expect(page).to have_content(july_calendar.short_name)
      #   expect(page).not_to have_content(calendars.first.short_name)
      #   select '18', from: 'q_contains_date_3i'
      #   select 'juillet', from: 'q_contains_date_2i'
      #   select '2017', from: 'q_contains_date_1i'
      #   click_button 'filter_btn'
      #   expect(page).to have_content(july_calendar.short_name)
      #   expect(page).not_to have_content(calendars.first.short_name)
      # end
    end
  end

  describe 'show' do
    it 'displays calendar' do
      visit calendar_path(calendars.first)
      expect(page).to have_content(calendars.first.name)
    end
  end
end
