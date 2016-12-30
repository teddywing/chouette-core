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
      xit 'supports filtering by short name' do
      end

      xit 'supports filtering by shared' do
      end

      xit 'supports filtering by date' do
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
