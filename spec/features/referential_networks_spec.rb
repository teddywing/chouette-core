# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'ReferentialNetworks', type: :feature do
  login_user

  let(:referential) { Referential.first }
  let!(:networks) { Array.new(2) { create :network, line_referential: referential.line_referential } }

  describe 'index' do
    before(:each) { visit referential_networks_path(referential) }

    it 'displays referential networks' do
      expect(page).to have_content(networks.first.name)
      expect(page).to have_content(networks.last.name)
    end

    context 'filtering' do
      it 'supports filtering by name' do
        fill_in 'q[name_or_objectid_cont]', with: networks.first.name
        click_button 'search-btn'
        expect(page).to have_content(networks.first.name)
        expect(page).not_to have_content(networks.last.name)
      end

      it 'supports filtering by objectid' do
        fill_in 'q[name_or_objectid_cont]', with: networks.first.objectid
        click_button 'search-btn'
        expect(page).to have_content(networks.first.name)
        expect(page).not_to have_content(networks.last.name)
      end
    end
  end

  describe 'show' do
    it 'displays referential network' do
      visit referential_network_path(referential, networks.first)
      expect(page).to have_content(networks.first.name)
    end
  end
end
