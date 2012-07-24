db = require('../bootstrap').basedata

Schema = db.Schema

Exam = new Schema
  id: Schema.ObjectId
  date: String

module.exports = db.model 'Exam', Exam
