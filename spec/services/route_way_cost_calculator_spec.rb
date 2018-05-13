RSpec.describe RouteWayCostCalculator do
  describe "#calculate!" do
    it "calculates and stores WayCosts in the given route's #cost field" do
      route = create(:route)

      allow(TomTom).to receive(:api_key).and_return('dummy')

      # Fake the request to the TomTom API, but don't actually send the right
      # things in the request or response. This is just to fake the request so
      # we don't actually call their API in tests. The test doesn't test
      # anything given in the response.
      stub_request(
        :post,
        "https://api.tomtom.com/routing/1/matrix/json?key=dummy&routeType=shortest&traffic=false&travelMode=bus"
      )
        .with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type'=>'application/json',
            'User-Agent'=>'Faraday v0.9.2'
          })
        .to_return(
          status: 200,
          body: "{\"formatVersion\":\"0.0.1\",\"matrix\":[[{\"statusCode\":200,\"response\":{\"routeSummary\":{\"lengthInMeters\":0,\"travelTimeInSeconds\":0,\"trafficDelayInSeconds\":0,\"departureTime\":\"2018-03-23T11:20:17+01:00\",\"arrivalTime\":\"2018-03-23T11:20:17+01:00\"}}}]]}",
          headers: {}
        )

      RouteWayCostCalculator.new(route).calculate!

      expect(route.costs).not_to be_nil
      expect { JSON.parse(JSON.dump(route.costs)) }.not_to raise_error
    end
  end
end
