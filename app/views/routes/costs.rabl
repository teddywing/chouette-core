object @route
node :costs do
  RouteWayCostJSONSerializer.dump(@route.costs)
end
