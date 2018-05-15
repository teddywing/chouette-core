import I18n from '../../../public/javascripts/i18n'
import decorateI18n from '../../../app/assets/javascripts/i18n/extended.coffee'
window.I18n = decorateI18n(I18n)
I18n.locale = "fr"

import fs from 'fs'
eval(fs.readFileSync('./public/javascripts/translations.js')+'')

module.exports = I18n
