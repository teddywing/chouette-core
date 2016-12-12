# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'RoutingConstraintZones', type: :feature do
  login_user

  let(:referential) { Referential.first }
  let!(:line) { create :line }
  let!(:routing_constraint_zones) { Array.new(2) { create :routing_constraint_zone, line: line } }

  describe 'index' do
    before(:each) { visit referential_line_routing_constraint_zones_path(referential, line) }

    it 'displays referential routing constraint zones' do
      expect(page).to have_content(routing_constraint_zones.first.name)
      expect(page).to have_content(routing_constraint_zones.last.name)
    end
  end

  describe 'show' do
    it 'displays referential routing constraint zone' do
      visit referential_line_routing_constraint_zone_path(referential, line, routing_constraint_zones.first)
      expect(page).to have_content(routing_constraint_zones.first.name)
    end
  end
end
