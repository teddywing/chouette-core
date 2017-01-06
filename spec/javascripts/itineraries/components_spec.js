var React = require('react');
var Provider = require('react-redux').Provider;
var actions = require('es6_browserified/itineraries/actions/index');
var App = require('es6_browserified/itineraries/components/TodoList');
var ConnectedApp = require('es6_browserified/itineraries/containers/VisibleTodoList');
var TestUtils = require('react-addons-test-utils');

xdescribe('ConnectedApp', function() {
  var connectedApp, store, initialItems;
  var state;
  state = [
    {
      text: 'first',
      index: 0,
      for_boarding: 'normal',
      for_alighting: 'normal'
    },
    {
      text: 'second',
      index: 1,
      for_boarding: 'normal',
      for_alighting: 'normal'
    }
  ]

  beforeEach(function() {
    store = state
  });

  describe('state provided by the store', function() {
    beforeEach(function() {
      connectedApp = TestUtils.renderIntoDocument(<Provider store={store}><ConnectedApp/></Provider>);
    });

    it('passes down items', function() {
          app = TestUtils.findRenderedComponentWithType(connectedApp, App);
          expect(app.props.items).toEqual(initialItems);
        });
      });
});
