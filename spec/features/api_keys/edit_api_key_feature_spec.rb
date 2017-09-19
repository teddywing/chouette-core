RSpec.describe 'New API Key', type: :feature do
  login_user

  describe "api_keys#edit" do

    let!( :api_key ){ create :api_key, name: SecureRandom.uuid, organisation: @user.organisation }

    let( :edit_label ){ "#{api_key.name} : #{api_key.token}" }
    let( :name_label ){ "Nom" }
    let( :validate_label ){ "Valider" }

    let( :unique_name ){ SecureRandom.uuid }

    it 'complete workflow' do
      # /workbenches
      visit workbenches_path 
      # api_key's new name does not exist yet
      expect( page ).not_to have_content(unique_name)
      # the api_key is visible
      click_link edit_label

      # brings us to correct page
      expect(page.current_path).to eq(edit_api_key_path(api_key))
      fill_in(name_label, with: unique_name)
      click_button(validate_label)

      # check impact on DB
      expect(api_key.reload.name).to eq(unique_name)

      # check redirect and changed display
      expect(page.current_path).to eq(workbenches_path)
      # changed api_key's name exists now
      expect( page ).to have_content(unique_name)
    end

  end

end
  
