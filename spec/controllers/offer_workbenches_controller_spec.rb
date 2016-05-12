require 'spec_helper'

RSpec.describe OfferWorkbenchesController, :type => :controller do
  let(:offerworkbench) { create :offer_workbench }

  describe "GET show" do
    it "returns http success" do
      get :show, id: offerworkbench.id
      expect(response).to have_http_status(302)
    end
  end

end
