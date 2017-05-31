# -*- coding: utf-8 -*-
describe "Referentials", :type => :feature do
  login_user

  let(:referential) { Referential.first }

  describe "index" do

    # FIXME #823
    # it "should support no referential" do
    #   visit referentials_path
    #   expect(page).to have_content("Jeux de Données")
    # end

    context "when several referentials exist" do

      def retrieve_referential_by_slug( slug)
        @user.organisation.referentials.find_by_slug(slug) ||
          create(:referential, :slug => slug, :name => slug, :organisation => @user.organisation)
      end

      let!(:referentials) { [ retrieve_referential_by_slug("aa"),
                              retrieve_referential_by_slug("bb")] }

      # FIXME #823
      # it "should show n referentials" do
      #   visit referentials_path
      #   expect(page).to have_content(referentials.first.name)
      #   expect(page).to have_content(referentials.last.name)
      # end

    end

  end

  describe "show" do
    before(:each) { visit referential_path(referential) }

    it "displays referential" do
      expect(page).to have_content(referential.name)
    end

    context 'archived referential' do
      it 'link to edit referetnial is not displayed' do
        referential.archive!
        visit referential_path(referential)
        expect(page).not_to have_link(I18n.t('actions.edit'), href: edit_referential_path(referential))
      end
    end

    context 'unarchived referential' do
      it 'link to edit referetnial is displayed' do
        expect(page).to have_link(I18n.t('actions.edit'), href: edit_referential_path(referential))
      end
    end

    context 'user has the permission to create referentials' do
      it 'shows the clone link for referetnial' do
        expect(page).to have_link(I18n.t('actions.clone'), href: new_referential_path(from: referential.id))
      end
    end

    context 'user does not have the permission to create referentials' do
      it 'does not show the clone link for referetnial' do
        @user.update_attribute(:permissions, [])
        visit referential_path(referential)
        expect(page).not_to have_link(I18n.t('actions.clone'), href: new_referential_path(from: referential.id))
      end
    end

    context 'user has the permission to edit referentials' do
      it 'shows the link to edit the referential' do
        expect(page).to have_link(I18n.t('actions.edit'), href: edit_referential_path(referential))
      end

      it 'shows the link to archive the referential' do
        expect(page).to have_link(I18n.t('actions.archive'), href: archive_referential_path(referential))
      end
    end

    context 'user does not have the permission to edit referentials' do
      before(:each) do
        @user.update_attribute(:permissions, [])
        visit referential_path(referential)
      end

      it 'does not show the link to edit the referential' do
        expect(page).not_to have_link(I18n.t('actions.edit'), href: edit_referential_path(referential))
      end

      it 'does not show the link to archive the referential' do
        expect(page).not_to have_link(I18n.t('actions.archive'), href: archive_referential_path(referential))
      end
    end

    context 'user has the permission to destroy referentials' do
      it 'shows the link to destroy the referential' do
        expect(page).to have_link(I18n.t('actions.destroy'), href: referential_path(referential))
      end
    end

    context 'user does not have the permission to destroy referentials' do
      it 'does not show the destroy link for referetnial' do
        @user.update_attribute(:permissions, [])
        visit referential_path(referential)
        expect(page).not_to have_link(I18n.t('actions.destroy'), href: referential_path(referential))
      end
    end
  end

  describe "create" do

    it "should" do
      visit new_referential_path
      fill_in "Nom", :with => "Test"
      fill_in "Code", :with => "test"
      fill_in "Point haut/droite de l'emprise par défaut", :with => "0.0, 0.0"
      fill_in "Point bas/gauche de l'emprise par défaut", :with => "1.0, 1.0"
      click_button "Valider"

      expect(Referential.where(:name => "Test")).not_to be_nil
      # CREATE SCHEMA
    end

  end

  describe "destroy" do
    let(:referential) {  create(:referential, :organisation => @user.organisation) }

    it "should remove referential" do
      visit referential_path(referential)
      #click_link "Supprimer"
      #expect(Referential.where(:slug => referential.slug)).to be_blank
    end

  end

end
