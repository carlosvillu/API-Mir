module.exports = (app) ->
  configDB = app.get('config').db
  db = require 'mongoose'

  conn = db.createConnection configDB.host, configDB.database, configDB.port
  conn.on 'open', -> console.log "Data Base connecting in mongodb://#{configDB.host}:#{configDB.port}/#{configDB.database}/"
  conn.on 'error', ->
    throw new Error 'DB connect error'

  # Global access to the db :(
  app.set 'db', db

