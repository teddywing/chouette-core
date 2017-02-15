var React = require('react');
var shallow = require('enzyme').shallow;
var mount = require('enzyme').mount;
var StopPointList = require('es6_browserified/itineraries/components/StopPointList');
var StopPoint = require('es6_browserified/itineraries/components/StopPoint');
var sinon = require('sinon')

describe('(Component) StopPointList', () => {
  it('renders without exploding', () => {
    const wrapper = shallow(<StopPointList
      stopPoints = {[]}
      onChange = {() => {}}
      onMoveDownClick={() => {}}
      onMoveUpClick={() => {}}
      onDeleteClick={() => {}}
      onSelectChange={() => {}}
      onSelectMarker={() => {}}
      onUnselectMarker={() => {}}
    />);
    expect(wrapper.length).toEqual(1);
  });

  it('simulates click events', () => {
    const state = {
      text: 'first',
      index: 0,
      for_boarding: 'normal',
      for_alighting: 'normal',
      user_objectid: '',
      olMap: {
        isOpened: false,
        json: {}
      }
    }
    const onButtonClick = sinon.spy();
    const wrapper = mount(<StopPoint
      value = {state}
      onChange = {() => {}}
      onMoveDownClick={() => {}}
      onMoveUpClick={() => {}}
      onDeleteClick={onButtonClick}
      onSelectChange={() => {}}
      onSelectMarker={() => {}}
      onToggleMap={() => {}}
      onUnselectMarker={() => {}}
      first= {true}
      last= {true}
      index= {0}
    />);
    wrapper.find('.delete').simulate('click');
    expect(onButtonClick.calledOnce).toEqual(true);
  });
});
