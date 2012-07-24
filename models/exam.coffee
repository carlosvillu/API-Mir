{ db, conn } = require('../bootstrap/database')

Schema = db.Schema

Exam = new Schema
  id: Schema.ObjectId
  date: String

module.exports = conn.model 'Exam', Exam
