# language: fr

##### Alors #####
Alors(/^je ne dois pas pouvoir visiter la page (.+)$/) do |name|
  case name
    when "d'accueil"
      visit root_path
  end
  expect(page.status_code).to eq(403)
end