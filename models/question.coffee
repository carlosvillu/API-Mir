{ db, conn } = require('../bootstrap/database')

Schema = db.Schema

# That is crappy, in the future i will change that to reference at two new object Questions and Answers, to will be able tranking changes in that fields
Question = new Schema
  id: Schema.ObjectId
  answers: Array
  text: String
, strict: true

exports.Model = conn.model 'Question', Question
exports.Schema = Question
