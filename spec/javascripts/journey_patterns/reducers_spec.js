var jpReducer = require('es6_browserified/journey_patterns/reducers/journeyPatterns')
let state = []
describe('journeyPatterns reducer', () => {
  beforeEach(()=>{
    state = [
      {
        deletable: false,
        name: 'm1',
        object_id : 'o1',
        published_name: 'M1',
        registration_number: '',
        stop_points: [{
          area_type : "lda",
          checked : false,
          id : 45289,
          name : "Clichy Levallois",
          object_id : "FR:92044:LDA:72073:STIF",
          object_version : 1,
          position : 0,
        },{
          area_type : "lda",
          checked : false,
          id : 40534,
          name : "Thomas Lemaître",
          object_id : "FR:92050:LDA:70915:STIF",
          object_version : 1,
          position : 1,
        }]
      },
      {
        deletable: false,
        name: 'm2',
        object_id : 'o2',
        published_name: 'M2',
        registration_number: '',
        stop_points: [{
          area_type : "lda",
          checked : false,
          id : 45289,
          name : "Clichy Levallois",
          object_id : "FR:92044:LDA:72073:STIF",
          object_version : 1,
          position : 0,
        },{
          area_type : "lda",
          checked : false,
          id : 40534,
          name : "Thomas Lemaître",
          object_id : "FR:92050:LDA:70915:STIF",
          object_version : 1,
          position : 1,
        }]
      },
    ]
  })

  it('should return the initial state', () => {
    expect(
      jpReducer(undefined, {})
    ).toEqual([])
  })

})
