Exam = require('../models/exam').Model
TYPE = 'mir'

module.exports = (app) ->

  # GET /v1/mir/:date
  app.get '/v1/mir/:date', (req, res) ->
    Exam.findOne date: req.params.date, (err, doc) ->
      doc.set 'questions', "https://#{req.headers.host}/v#{app.get 'api version'}/#{TYPE}/#{req.params.date}/questions"
      res.json(doc)

  app.post '/v1/mir', (req, res)->
    exam = new Exam type:"#{TYPE}", date: req.body.date, last_modified: Date.now()
    exam.save (err, doc, count) ->
      doc.set 'questions', "https://#{req.headers.host}/v#{app.get 'api version'}/#{TYPE}/#{req.body.date}/questions"
      res.header 'Location', "https://#{req.headers.host}/v#{app.get 'api version'}/#{TYPE}/#{req.body.date}"
      res.json(201, doc.toJSON())
