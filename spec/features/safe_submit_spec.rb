RSpec.describe 'SafeSubmit', type: :feature do
  login_user

  let( :path ){ new_api_key_path() }
  it 'view shows the corresponding buttons' do
    visit path
    expect(page).to have_css('input[type=submit][data-disable-with]')
  end
end
