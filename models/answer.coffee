module.exports = (app) ->
  db = app.get 'db'
  Schema = db.Schema

  ExamSchema = new Schema
    date: Integer,


  
