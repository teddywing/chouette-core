# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'ReferentialLines', type: :feature do
  login_user

  let(:referential) { Referential.first }
  let(:group_of_lines) { Array.new(2) { create(:group_of_line, line_referential: Referential.first.line_referential) } }

  describe 'index' do
    before(:each) { visit referential_group_of_lines_path(referentialre) }

    it 'displays referential groups of lines' do
      expect(page).to have_content(group_of_lines.first.name)
      expect(page).to have_content(group_of_lines.last.name)
    end

    context 'fitering' do
      it 'supports filtering by name' do
        fill_in 'q[name_cont]', with: group_of_lines.first.name
        click_button 'search-btn'
        expect(page).to have_content(group_of_lines.first.name)
        expect(page).not_to have_content(group_of_lines.last.name)
      end
    end
  end

  describe 'show' do
    it 'displays referential group of lines' do
      visit referential_group_of_line_path(referential, group_of_lines.first)
      expect(page).to have_content(group_of_lines.first.name)
    end
  end
end
