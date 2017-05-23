# -*- coding: utf-8 -*-
require 'spec_helper'

describe "TimeTables", :type => :feature do
  login_user

  let!(:time_tables) { Array.new(2) { create(:time_table) } }
  let(:time_table) { time_tables.first }
  subject { time_tables.first }

  describe "index" do
    before(:each) { visit referential_time_tables_path(referential) }

    it "displays time_tables" do
      expect(page).to have_content(time_tables.first.comment)
      expect(page).to have_content(time_tables.last.comment)
    end

    context 'user has permission to create time tables' do
      it 'shows a create link for time tables' do
        expect(page).to have_content(I18n.t('actions.add'))
      end
    end

    context 'user does not have permission to create time tables' do
      it 'does not show a create link for time tables' do
        @user.update_attribute(:permissions, [])
        visit referential_time_tables_path(referential)
        expect(page).not_to have_content(I18n.t('actions.add'))
      end
    end

    context 'user has permission to edit time tables' do
      it 'shows an edit button for time tables' do
        expect(page).to have_content(I18n.t('actions.edit'))
      end
    end

    context 'user does not have permission to edit time tables' do
      it 'does not show a edit link for time tables' do
        @user.update_attribute(:permissions, [])
        visit referential_time_tables_path(referential)
        expect(page).not_to have_content(I18n.t('actions.add'))
      end
    end

    context 'user has permission to destroy time tables' do
      it 'shows a destroy button for time tables' do
        expect(page).to have_content(I18n.t('actions.delete'))
      end
    end

    context 'user does not have permission to destroy time tables' do
      it 'does not show a destroy button for time tables' do
        @user.update_attribute(:permissions, [])
        visit referential_time_tables_path(referential)
        expect(page).not_to have_content(I18n.t('actions.delete'))
      end
    end

  end

  describe "show" do
    before(:each) { visit referential_time_table_path(referential, time_table) }

    it "displays time_table" do
      expect(page).to have_content(time_tables.first.comment)
    end

    it 'should not show actualize link on time_tabl without calendar' do
      expect(page).not_to have_content(I18n.t('time_tables.actions.actualize'))
    end

    # context 'user has permission to create time tables' do
    #   it 'shows a create link for time tables' do
    #     expect(page).to have_content(I18n.t('time_tables.actions.new'))
    #   end
    #
    #   it 'does not show link to duplicate the time table' do
    #     expect(page).to have_content(I18n.t('time_tables.actions.duplicate'))
    #   end
    # end

    context 'user does not have permission to create time tables' do
      it 'does not show a create link for time tables' do
        @user.update_attribute(:permissions, [])
        visit referential_time_table_path(referential, time_table)
        expect(page).not_to have_content(I18n.t('actions.add'))
      end

      it 'does not show link to duplicate the time table' do
        @user.update_attribute(:permissions, [])
        visit referential_time_table_path(referential, time_table)
        expect(page).not_to have_content(I18n.t('actions.duplicate'))
      end
    end

    context 'user has permission to edit time tables' do
      it 'shows the edit link for time table' do
        expect(page).to have_content(I18n.t('actions.edit'))
      end
    end

    context 'user does not have permission to edit time tables' do
      it 'does not show the edit link for time table' do
        @user.update_attribute(:permissions, [])
        visit referential_time_table_path(referential, time_table)
        expect(page).not_to have_content(I18n.t('actions.edit'))
      end
    end

    context 'user has permission to destroy time tables' do
      it 'shows the destroy link for time table' do
        expect(page).to have_content(I18n.t('actions.destroy'))
      end
    end

    context 'user does not have permission to destroy time tables' do
      it 'does not show a destroy link for time table' do
        @user.update_attribute(:permissions, [])
        visit referential_time_table_path(referential, time_table)
        expect(page).not_to have_content(I18n.t('actions.destroy'))
      end
    end
  end

  # No more test for the form, as it is now managed by React/Redux.

end
