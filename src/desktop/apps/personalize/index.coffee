#
# Personalize page
#

express = require 'express'
{ index } = require './routes.js'
adminOnly = require '../../lib/admin_only'

app = module.exports = express()
app.set 'views', __dirname
app.set 'view engine', 'jade'

app.get '/personalize', index
app.get '/personalize/:slug', index
