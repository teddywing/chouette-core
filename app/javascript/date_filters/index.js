const calendarDF = require('./calendar')
const complianceControlSetDF = require('./compliance_control_set')
const timetableDF = require('./time_table')
const importDF = require('./import')
const workbenchDF = require('./workbench')

module.exports = {
  calendarDF: () => calendarDF,
  complianceControlSetDF: () => complianceControlSetDF,
  timetableDF: () => timetableDF,
  importDF: () => importDF,
  workbenchDF: () => workbenchDF
}