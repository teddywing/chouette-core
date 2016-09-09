# language: fr

##### Utility methods #####
def create_user email, password, username
  Fabricate.build(:user, email: email, username: username, password: password).save
end

##### Etant donné #####
Etantdonné(/^un compte confirmé pour "([^\"]+)"(?: avec un nom d'utilisateur "(.+)")?$/) do |email, username|
  username ||= email.split("@").first
  create_user email, 'password', username
end

Etantdonnéque(/^je suis déconnecté$/) do
  # visit destroy_user_session_path
end