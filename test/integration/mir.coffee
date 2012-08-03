app = require '../../app'
should = require 'should'
request = require 'supertest'
async = require 'async'
{ cleanDB, insertExam } = require('../helpers/db')
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

  it "POST /v#{app.get 'api version'}/#{TYPE} should return a new exam created", (done)->
    request(app)
      .post("/v#{app.get 'api version'}/#{TYPE}")
      .send({date: 2008})
      .end (err, res)->
        res.statusCode.should.be.eql 201
        res.body.should.have.property('_id')
        res.body.should.have.property('date').and.be.eql 2008
        res.body.should.have.property('type').and.be.eql "#{TYPE}"
        res.body.should.have.property('questions').and.match /\/v1\/mir\/2008\/questions/
        done(err)



