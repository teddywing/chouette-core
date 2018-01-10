import React, { Component } from 'react'
import PropTypes from 'prop-types'
import actions from '../actions'

export default class SaveJourneyPattern extends Component {
  constructor(props){
    super(props)
  }

  btnDisabled(){
    return !this.props.status.fetchSuccess || this.props.status.isFetching
  }

  btnClass(){
    let className = ['btn btn-default']
    if(this.btnDisabled()){
      className.push('disabled')
    }
    return className.join(' ')
  }

  render() {
    if(this.props.status.policy['journey_patterns.update'] == false) {
      return false
    }else{
      return (
        <div className='row mt-md'>
          <div className='col-lg-12 text-right'>
            <form className='jp_collection formSubmitr ml-xs' onSubmit={e => {e.preventDefault()}}>
              <button
                className={this.btnClass()}
                type='button'
                disabled={this.btnDisabled()}
                onClick={e => {
                  e.preventDefault()
                  this.props.editMode ? this.props.onSubmitJourneyPattern(this.props.dispatch, this.props.journeyPatterns) : this.props.onEnterEditMode()
                }}
                >
                {this.props.editMode ? "Valider" : "Editer"}
              </button>
            </form>
          </div>
        </div>
      )
    }
  }
}

SaveJourneyPattern.propTypes = {
  journeyPatterns: PropTypes.array.isRequired,
  status: PropTypes.object.isRequired,
  page: PropTypes.number.isRequired
}
