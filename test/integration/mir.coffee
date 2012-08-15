app = require '../../app'
mhould = require 'should'
request = require 'supertest'
async = require 'async'
{ cleanDB, insertExam, insertDocumentInCollection } = require('../helpers/db')
TYPE = "mir"


describe "Resource Exam", ->
  beforeEach (done) ->
    cleanDB done
    
  it "GET /v#{app.get 'api version'}/#{TYPE}/2011 should return an exam of this date", (done)->
    req = request app
    async.series
      create: (cb) ->
        insertExam date:2011, type: "#{TYPE}", cb
      test: (cb) ->
        req.get("/v#{app.get 'api version'}/#{TYPE}/2011")
          .end(cb)
    , (err, results) ->
      results.test.body.should.have.property('_id')
      results.test.body.should.have.property('date').and.be.eql 2011
      results.test.body.should.have.property('type').and.be.eql "#{TYPE}"
      results.test.body.should.have.property('questions').and.match /\/v1\/mir\/2011\/questions/
      results.test.statusCode.should.be.eql 200
      done err

  it "GET error date should return a 404 error code", (done)->
    request(app)
      .get("/v#{app.get 'api version'}/#{TYPE}/2001")
      .expect(404, done)

  it "POST /v#{app.get 'api version'}/#{TYPE} should return a new exam created", (done)->
    request(app)
      .post("/v#{app.get 'api version'}/#{TYPE}")
      .send({date: 2008})
      .end (err, res)->
        res.statusCode.should.be.eql 201
        res.body.should.have.property('_id')
        res.body.should.have.property('date').and.be.eql 2008
        res.body.should.have.property('type').and.be.eql "#{TYPE}"
        res.headers.should.have.property('location').and.be.match /\/v1\/mir\/2008/
        res.body.should.have.property('questions').and.match /\/v1\/mir\/2008\/questions/
        done(err)

  it "PUT /v#{app.get 'api version'}/#{TYPE}/2008 should return an update document", (done) ->
    req = request(app)
    async.series
      create: (cb)->
        insertExam date: 2008, type: "#{TYPE}", last_modified: new Date(), cb
      test: (cb)->
        req.put("/v#{app.get 'api version'}/#{TYPE}/2008")
          .send(date:2009, type: 'mir')
          .end(cb)
      get: (cb)->
        req.get("/v#{app.get 'api version'}/#{TYPE}/2009")
          .end(cb)
    ,(err, results)->
        results.test.statusCode.should.be.eql 200
        results.test.body.should.have.property('_id')
        results.test.body.should.have.property('date').and.be.eql 2009
        results.test.body.should.have.property('type').and.be.eql "#{TYPE}"
        results.test.headers.should.have.property('location').and.be.match /\/v1\/mir\/2009/
        results.test.body.should.have.property('questions').and.match /\/v1\/mir\/2009\/questions/
        results.get.statusCode.should.be.eql 200
        done(err)

  it "DELETE /v#{app.get 'api version'}/#{TYPE}/2008 should delete the exam", (done)->
    req = request app
    async.series
      create: (cb)->
        insertExam date: 2008, type: "#{TYPE}", last_modified: new Date(), cb
      delete: (cb)->
        req.del("/v#{app.get 'api version'}/#{TYPE}/2008")
          .end(cb)
      get: (cb)->
        req.get("/v#{app.get 'api version'}/#{TYPE}/2008")
          .end(cb)
    ,(err, results)->
      results.delete.statusCode.should.be.eql 204
      results.get.statusCode.should.be.eql 404
      done err

describe "Resource Question", ->

  beforeEach (done) ->
    cleanDB done
    # InsertExam in the DB to will be able add new Questions

  it "GET /v1/:type/:date/questions", (done) ->
    id_exam_created = null
    async.series
      prepare: (cb) ->
        async.waterfall [
          (callback) ->
            insertDocumentInCollection date: 2011, type: "#{TYPE}", 'exams', callback
          ,(id_exam, callback) ->
            id_exam_created = id_exam
            insertDocumentInCollection
              id_exam: id_exam,
              text: 'Question One',
              answers: [{text: 'Answer One', correct: true},{text: 'Answer Two', correct: true}],
              'questions',
              callback
        ], cb
      get: (cb) ->
        request(app)
          .get("/v#{app.get 'api version'}/#{TYPE}/2011/questions")
          .end(cb)
      , (err, results) ->
          results.get.statusCode.should.be.eql 200
          results.get.body.should.be.an.instanceof Array
          results.get.body[0].should.have.property('id_exam').and.be.eql String(id_exam_created)
          done err


  it "GET /v1/:type/:date/questions/:id", (done) ->
    id_exam_created = null
    async.waterfall [
      (cb) ->
        insertDocumentInCollection date: 2011, type: "#{TYPE}", 'exams', cb
      , (id_exam, cb) ->
          id_exam_created = id_exam
          insertDocumentInCollection
            id_exam: id_exam,
            text: 'Question One',
            answers: [{text: 'Answer One', correct: true},{text: 'Answer Two', correct: true}],
            'questions',
            cb
      , (id_question, cb) ->
          request(app)
          .get("/v#{app.get 'api version'}/#{TYPE}/2011/questions/#{id_question}")
          .end(cb)
    ], (err, result) ->
      result.statusCode.should.be.eql 200
      result.body.should.be.an.instanceof Object
      result.body.should.have.property('id_exam').and.be.eql String(id_exam_created)
      result.body.should.have.property('answers').and.be.an.instanceof Array
      result.body.answers[0].should.be.an.instanceof(Object).and.have.property('text').and.be.eql 'Answer One'
      result.body.answers[0].should.be.an.instanceof(Object).and.have.property('correct').and.be.eql true
      done err

  it "POST /v1/:type/:date/questions"
  it "PUT /v1/:type/:date/questions/:id"
  it "DELETE /v1/:type/:date/questions/:id"
