# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'ReferentialLines', type: :feature do
  login_user
  let!(:referential_metadata) { create :referential_metadata, referential: referential }

  describe 'index' do
    before(:each) { visit referential_lines_path(referential) }

    it 'displays referential lines' do
      expect(page).to have_content(referential.lines.first.name)
      expect(page).to have_content(referential.lines.last.name)
    end

    it 'allows only R in CRUD' do
      expect(page).to have_content(I18n.t('actions.show'))
      expect(page).not_to have_content(I18n.t('actions.edit'))
      expect(page).not_to have_content(I18n.t('actions.destroy'))
      expect(page).not_to have_content(I18n.t('actions.add'))
    end

    context 'filtering' do
      it 'supports filtering by name' do
        fill_in 'q[name_or_number_or_objectid_cont]', with: referential.lines.first.name
        click_button 'search-btn'
        expect(page).to have_content(referential.lines.first.name)
        expect(page).not_to have_content(referential.lines.last.name)
      end

      it 'supports filtering by number' do
        fill_in 'q[name_or_number_or_objectid_cont]', with: referential.lines.first.number
        click_button 'search-btn'
        expect(page).to have_content(referential.lines.first.name)
        expect(page).not_to have_content(referential.lines.last.name)
      end

      it 'supports filtering by objectid' do
        fill_in 'q[name_or_number_or_objectid_cont]', with: referential.lines.first.objectid
        click_button 'search-btn'
        expect(page).to have_content(referential.lines.first.name)
        expect(page).not_to have_content(referential.lines.last.name)
      end
    end
  end

  describe 'show' do
    it 'displays referential line' do
      visit referential_line_path(referential, referential.lines.first)
      expect(page).to have_content(referential.lines.first.name)
    end
  end
end
