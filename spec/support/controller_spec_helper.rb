module ControllerSpecHelper
  def with_permission permission, &block
    context "with permission #{permission}" do
      login_user
      before(:each) do
        @user.permissions << permission
        @user.save!
        sign_in @user
      end
      context('', &block) if block_given?
    end
  end

end

RSpec.configure do |config|
  config.extend ControllerSpecHelper, type: :controller
end
