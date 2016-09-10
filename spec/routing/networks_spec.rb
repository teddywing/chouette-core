require 'spec_helper'

describe NetworksController do
  describe "routing" do
    it "not recognize #routes" do
      get( "/line_referentials/1/networks/2/routes").should_not route_to(
        :controller => "networks", :action => "routes",
        :line_referential_id => "1", :id => "2"
      )
    end
    it "not recognize #lines" do
      get( "/line_referentials/1/networks/2/lines").should_not route_to(
        :controller => "networks", :action => "lines",
        :line_referential_id => "1", :id => "2"
      )
    end
    it "recognize and generate #show" do
      get( "/line_referentials/1/networks/2").should route_to(
        :controller => "networks", :action => "show",
        :line_referential_id => "1", :id => "2"
      )
    end
  end
end

