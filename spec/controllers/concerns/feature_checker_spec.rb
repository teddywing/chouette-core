require "rails_helper"

RSpec.describe "FeatureChecker", type: :controller do

  controller do
    include FeatureChecker
    requires_feature :test, only: :protected

    def protected; render :text => "protected"; end
    def not_protected; render :text => "not protected"; end

    def current_organisation
      @organisation ||= Organisation.new
    end
  end

  before do
    routes.draw do
      get "protected" => "anonymous#protected"
      get "not_protected" => "anonymous#not_protected"
    end
  end

  it "refuse access when organisation has not the feature" do
    expect{ get(:protected) }.to raise_error(FeatureChecker::NotAuthorizedError)
  end

  it "accept access on unprotected action" do
    get :not_protected
  end

  it 'accept access when organisation has feature' do
    controller.current_organisation.features << "test"
    get :protected
  end
end
