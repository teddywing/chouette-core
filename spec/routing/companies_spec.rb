require 'spec_helper'

describe CompaniesController do
  describe "routing" do
    it "not recognize #routes" do
      get( "/line_referentials/1/companies/2/routes").should_not route_to(
        :controller => "companies", :action => "routes",
        :line_referential_id => "1", :id => "2"
      )
    end
    it "not recognize #lines" do
      get( "/line_referentials/1/companies/2/lines").should_not route_to(
        :controller => "companies", :action => "lines",
        :line_referential_id => "1", :id => "2"
      )
    end
    it "recognize and generate #show" do
      get( "/line_referentials/1/companies/2").should route_to(
        :controller => "companies", :action => "show",
        :line_referential_id => "1", :id => "2"
      )
    end
  end
end

