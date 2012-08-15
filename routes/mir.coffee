Exam = require('../models/exam').Model
Question = require('../models/question').Model
TYPE = 'mir'

module.exports = (app) ->

  createQuestionUrl = (host, date) ->
    "https://#{host}/v#{app.get 'api version'}/#{TYPE}/#{date}/questions"

  # GET /v1/mir/:date
  app.get '/v1/mir/:date', (req, res, next) ->
    Exam.findOne date: req.params.date, (err, doc) ->
      if doc
        doc.set 'questions', createQuestionUrl(req.headers.host, req.params.date)
        res.json(doc)
      else
        res.json(404, {error: "Not found"})

  app.post '/v1/mir', (req, res)->
    exam = new Exam type:"#{TYPE}", date: req.body.date, last_modified: Date.now()
    exam.save (err, doc, count) ->
      doc.set 'questions', createQuestionUrl(req.headers.host,req.body.date)
      res.header 'Location', "https://#{req.headers.host}/v#{app.get 'api version'}/#{TYPE}/#{req.body.date}"
      res.json(201, doc.toJSON())

  app.put '/v1/mir/:date', (req, res)->
    Exam.findOne date: req.params.date, (err, doc)->
      doc.set("#{field}", "#{value}") for field, value of req.body
      doc.set('last_modified', new Date())
      doc.save (err, doc, count)->
        doc.set 'questions', createQuestionUrl(req.headers.host, req.body.date)
        res.header 'Location', "https://#{req.headers.host}/v#{app.get 'api version'}/#{TYPE}/#{req.body.date}"
        res.json doc

  app.del '/v1/mir/:date', (req, res) ->
    Exam.remove date: req.params.date, (err, count) ->
      res.json(204, null)

  app.get '/v1/mir/:date/questions', (req, res) ->
    Exam.findOne date: req.params.date, (err, doc) ->
      if err
        res.json 404, {error: 'Exam not found'}
      else
        Question.find id_exam: doc._id, (err, docs) ->
          res.json 200, docs

  app.get '/v1/mir/:date/questions/:id', (req, res) ->
    Exam.findOne date: req.params.date, (err, doc) ->
      if err
        res.json 404, {error: "Exam not found"}
      else
        Question.findOne _id: req.params.id, (err, doc) ->
          if err
            res.json 404, {error: "Question not found"}
          else
            res.json 200, doc
