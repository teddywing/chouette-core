# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'ReferentialCompanies', type: :feature do
  login_user

  let(:referential) { Referential.first }
  let!(:companies) { Array.new(2) { create :company, line_referential: referential.line_referential } }

  describe 'index' do
    before(:each) { visit referential_companies_path(referential) }

    it 'displays referential companies' do
      expect(page).to have_content(companies.first.name)
      expect(page).to have_content(companies.last.name)
    end

    context 'fitering' do
      it 'supports filtering by name' do
        fill_in 'q[name_or_objectid_cont]', with: companies.first.name
        click_button 'search-btn'
        expect(page).to have_content(companies.first.name)
        expect(page).not_to have_content(companies.last.name)
      end

      it 'supports filtering by objectid' do
        fill_in 'q[name_or_objectid_cont]', with: companies.first.objectid
        click_button 'search-btn'
        expect(page).to have_content(companies.first.name)
        expect(page).not_to have_content(companies.last.name)
      end
    end
  end

  describe 'show' do
    it 'displays referential company' do
      visit referential_company_path(referential, companies.first)
      expect(page).to have_content(companies.first.name)
    end
  end
end
