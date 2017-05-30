[1mdiff --git a/app/assets/javascripts/es6_browserified/vehicle_journeys/components/tools/NotesEditVehicleJourney.js b/app/assets/javascripts/es6_browserified/vehicle_journeys/components/tools/NotesEditVehicleJourney.js[m
[1mindex d4c3f42..f248b28 100644[m
[1m--- a/app/assets/javascripts/es6_browserified/vehicle_journeys/components/tools/NotesEditVehicleJourney.js[m
[1m+++ b/app/assets/javascripts/es6_browserified/vehicle_journeys/components/tools/NotesEditVehicleJourney.js[m
[36m@@ -2,6 +2,7 @@[m [mvar React = require('react')[m
 var Component = require('react').Component[m
 var PropTypes = require('react').PropTypes[m
 var actions = require('../../actions')[m
[32m+[m[32mvar _ = require('lodash')[m
 [m
 class NotesEditVehicleJourney extends Component {[m
   constructor(props) {[m
[36m@@ -27,13 +28,13 @@[m [mclass NotesEditVehicleJourney extends Component {[m
         type='button'[m
         className='btn btn-outline-danger btn-xs'[m
         onClick={() => this.props.onToggleFootnoteModal(lf, false)}[m
[31m-      ><span className="fa fa-trash"></span></button>[m
[32m+[m[32m      ><span className="fa fa-trash"></span> Retirer</button>[m
     }else{[m
       return <button[m
         type='button'[m
         className='btn btn-outline-primary btn-xs'[m
         onClick={() => this.props.onToggleFootnoteModal(lf, true)}[m
[31m-      ><span className="fa fa-plus"></span></button>[m
[32m+[m[32m      ><span className="fa fa-plus"></span> Ajouter</button>[m
     }[m
   }[m
 [m
[36m@@ -65,7 +66,8 @@[m [mclass NotesEditVehicleJourney extends Component {[m
                   {(this.props.modal.type == 'notes_edit') && ([m
                     <form>[m
                       <div className='modal-body'>[m
[31m-                        {window.line_footnotes.map((lf, i) =>[m
[32m+[m[32m                        {/* notes */}[m
[32m+[m[32m                        {this.props.modal.modalProps.vehicleJourney.footnotes.map((lf, i) => {[m
                           <div[m
                             key={i}[m
                             className='panel panel-default'[m
[36m@@ -78,9 +80,11 @@[m [mclass NotesEditVehicleJourney extends Component {[m
                             </div>[m
                             <div className='panel-body'><p>{lf.label}</p></div>[m
                           </div>[m
[31m-                        )}[m
[32m+[m[32m                        })}[m
                       </div>[m
 [m
[32m+[m
[32m+[m
                       <div className='modal-footer'>[m
                         <button[m
                           className='btn btn-link'[m
[1mdiff --git a/app/assets/javascripts/es6_browserified/vehicle_journeys/index.js b/app/assets/javascripts/es6_browserified/vehicle_journeys/index.js[m
[1mindex 2a76ae4..489446a 100644[m
[1m--- a/app/assets/javascripts/es6_browserified/vehicle_journeys/index.js[m
[1m+++ b/app/assets/javascripts/es6_browserified/vehicle_journeys/index.js[m
[36m@@ -8,10 +8,10 @@[m [mvar actions = require("./actions")[m
 var enableBatching = require('./batch').enableBatching[m
 [m
 // logger, DO NOT REMOVE[m
[31m-// var applyMiddleware = require('redux').applyMiddleware[m
[31m-// var createLogger = require('redux-logger')[m
[31m-// var thunkMiddleware = require('redux-thunk').default[m
[31m-// var promise = require('redux-promise')[m
[32m+[m[32mvar applyMiddleware = require('redux').applyMiddleware[m
[32m+[m[32mvar createLogger = require('redux-logger')[m
[32m+[m[32mvar thunkMiddleware = require('redux-thunk').default[m
[32m+[m[32mvar promise = require('redux-promise')[m
 [m
 var selectedJP = [][m
 [m
[36m@@ -85,12 +85,12 @@[m [mif (window.jpOrigin){[m
   initialState.filters.queryString = actions.encodeParams(params)[m
 }[m
 [m
[31m-// const loggerMiddleware = createLogger()[m
[32m+[m[32mconst loggerMiddleware = createLogger()[m
 [m
 let store = createStore([m
   enableBatching(vehicleJourneysApp),[m
[31m-  initialState[m
[31m-  // applyMiddleware(thunkMiddleware, promise, loggerMiddleware)[m
[32m+[m[32m  initialState,[m
[32m+[m[32m  applyMiddleware(thunkMiddleware, promise, loggerMiddleware)[m
 )[m
 [m
 render([m
