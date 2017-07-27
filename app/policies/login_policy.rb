# Headless as described here https://github.com/elabs/pundit#headless-policies
class LoginPolicy

  attr_reader :user
  def initialize user
    @user = user
  end

  def boiv?
    (user.permissions || []).include?('sessions:create')
  end

end
