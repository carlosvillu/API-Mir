app = require '../../app'
request = require '../helpers/http'
should = require 'should'
Exam = null

# Bootstraping must be finished
process.nextTick ->
  Exam = require('../../models/exam').Model

fixtures =
  exam: require '../fixtures/exam'


describe 'Model Exam', ->
  it 'should be a exam model', ->
    should.exist Exam

  before (done) ->
    Exam.remove {}, =>
      @exam = new Exam(fixtures.exam)
      done()
  describe 'Exam CRUD', ->
    it 'should be possible create a new exam', (done) ->
      @exam.save (err) ->
        Exam.count date: 2012, (err, count) ->
          count.should.be.eql 1
          done(err)

    it 'should be field for type, last_modified', (done) ->
      @exam.save (err) ->
        Exam.findOne date: 2012, (err, doc) ->
          doc.should.have.property('type')
          doc.should.have.property('last_modified')
          done err

     
    it 'should be possible read an exam', (done) ->
      Exam.findOne date: 2012, (err, doc) ->
        done(err)

    it 'should be possible delete an exam', (done) ->
      Exam.remove type: 'mir', (err, count)->
        count.should.be.eql 1
        done(err)
