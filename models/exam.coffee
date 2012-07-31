{ db, conn } = require('../bootstrap/database')

Schema = db.Schema

# That is crappy, in the future i will change that to reference at two new object Questions and Answers, to will be able tranking changes in that fields
Exam = new Schema
  id: Schema.ObjectId
  date: Number
  type: {type: String, index: true, required: true}
  last_modified: type: Date, default: Date.now
, strict: true

###
  TODO:
  CREATE A STATIC METHOD TO GET THE QUESTIONS FOR AN EXAM
  http://mongoosejs.com/docs/methods-statics.html
###

exports.Model = conn.model 'Exam', Exam
exports.Schema = Exam
