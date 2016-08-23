Fabricator :user do
  email     { sequence(:email) { |i| "user#{i}@example.com" } }
  name { sequence(:name) { |i| "fname#{i}" } }
  
  password { 'password' }

  username { "#{FFaker::Name.first_name.parameterize}.#{FFaker::Name.last_name.parameterize}" }
end