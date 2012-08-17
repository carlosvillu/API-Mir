express = require 'express'

app = express()

app.configure ->
  app.set 'config', require "./config/#{process.env.NODE_ENV}.json"
  app.set 'api version', 1
  app.use(express.favicon())
  app.use(express.logger('dev'))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)
  app.use( (req, res) -> res.json 400, {error: "Bad Request"} )


app.configure 'development', ->
  app.use(express.errorHandler())

require('./bootstrap')

module.exports = app
