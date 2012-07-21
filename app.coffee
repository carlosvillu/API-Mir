express = require 'express'

app = express()

app.configure ->
  app.set 'config', require "./config/#{process.env.NODE_ENV}.json"
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use(express.favicon())
  app.use(express.logger('dev'))
  app.use(express.static("#{__dirname}/public"))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)


app.configure 'development', ->
  app.use(express.errorHandler())

require('./bootstrap')(app)
require('./models')(app)
require('./routes')(app)

module.exports = app
