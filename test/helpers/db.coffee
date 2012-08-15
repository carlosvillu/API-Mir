Db = require('mongodb').Db
Server = require('mongodb').Server
async = require 'async'
app = require '../../app'

configDB = app.get('config').db

# Clean data base to have fresh one
exports.cleanDB = (done) ->
  client = null
  async.waterfall [
    (cb) ->
      client = db = new Db(configDB.database, new Server(configDB.host, configDB.port, {}), {native_parser:true})
      db.open cb
    ,(db, cb) ->
      db.dropDatabase cb
  ], (err, results) -> client.close(); done err

exports.insertExam = (exam, cb) ->
  client = null
  async.waterfall [
    (cb) ->
      client = db = new Db(configDB.database, new Server(configDB.host, configDB.port, {}), {native_parser:true})
      db.open cb
    ,(db, cb) ->
      db.collection 'exams', cb
    ,(collection, cb) ->
      collection.insert exam, cb
  ], (err, result) -> client.close(); cb(err)

exports.insertDocumentInCollection = (doc, collection, cb) ->
  client = null
  async.waterfall [
    (cb) ->
      client = db = new Db(configDB.database, new Server(configDB.host, configDB.port, {}), {native_parser:true})
      db.open cb
    ,(db, cb) ->
      db.collection collection, cb
    ,(collection, cb) ->
      collection.insert doc, cb
  ], (err, result) -> client.close(); cb(err, result[0]._id)
