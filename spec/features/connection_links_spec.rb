# coding: utf-8
RSpec.describe "ConnectionLinks", type: :feature do
  login_user

  let!(:connection_links) { Array.new(2) { create(:connection_link) } }
  subject { connection_links.first }

  describe "list" do
    it "display connection_links" do
      visit referential_connection_links_path(referential)
      expect(page).to have_content(connection_links.first.name)
      expect(page).to have_content(connection_links.last.name)
    end

  end

  describe "show" do
    it "display connection_link" do
      visit referential_connection_links_path(referential)
      click_link "#{connection_links.first.name}"
      expect(page).to have_content(connection_links.first.name)
    end
  end

  describe "new" do
    it "creates connection_link and return to show" do
      visit referential_connection_links_path(referential)
      click_link "Ajouter une correspondance"
      fill_in "Nom", :with => "ConnectionLink 1"
      fill_in "Identifiant Neptune", :with => "test:ConnectionLink:1:LOC"
      click_button("Créer correspondance")
      expect(page).to have_content("ConnectionLink 1")
    end
  end

  describe "edit and return to show" do
    it "edit connection_link" do
      visit referential_connection_link_path(referential, subject)
      click_link "Editer cette correspondance"
      fill_in "Nom", :with => "ConnectionLink Modified"
      click_button("Editer correspondance")
      expect(page).to have_content("ConnectionLink Modified")
    end
  end

end
