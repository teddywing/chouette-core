describe 'ReferentialLines', type: :feature do
  login_user
  let!(:referential_metadata) { create :referential_metadata, referential: referential }

  describe 'show' do
    it 'displays referential line' do
      visit referential_line_path(referential, referential.lines.first)
      expect(page).to have_content(referential.lines.first.name)
    end
    it 'displays referential line' do
      visit referential_line_path(referential, referential.lines.first, sort: "stop_points")
      expect(page).to have_content(referential.lines.first.name)
    end
  end
end
