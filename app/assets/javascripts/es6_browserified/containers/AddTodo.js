import React from 'react'
import { connect } from 'react-redux'
import actions from '../actions'

let AddTodo = ({ dispatch }) => {
  return (
    <div className="clearfix" style={{marginBottom: 10}}>
      <form onSubmit={e => {
        e.preventDefault()
        dispatch(actions.addStop())
      }}>
        <button type="submit" className="btn btn-primary btn-xs pull-right">
          <span className="fa fa-plus"></span> Ajouter un arrêt
        </button>
      </form>
    </div>
  )
}
AddTodo = connect()(AddTodo)

export default AddTodo
