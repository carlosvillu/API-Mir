module.exports = (app) ->
  db = app.get 'db'
  Schema = db.Schema

  Exam = new Schema
    id: Schema.ObjectId
    date: String

  db.model 'Exam', Exam
