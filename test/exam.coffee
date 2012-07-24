app = require '../app'
request = require './helpers/http'
should = require 'should'
Exam = null

# Bootstraping must be finished
process.nextTick ->
  Exam = require '../models/exam'

fixtures =
  exam: require './fixtures/exam'


describe 'Model Exam', ->
  it 'should be a exam model', ->
    should.exist Exam

  before (done) ->
    Exam.remove {}, =>
      @exam = new Exam()
      done()
  describe 'Exam CRUD', ->
    it 'should be possible create a new exam', (done) ->
      @exam.date = +new Date()
      @exam.save (err) ->
        Exam.count {}, (err, count) ->
          count.should.be.eql 1
          done(err)

    it 'should be posible update an exam'
    it 'should be possible read an exam'
    it 'should be possible delete an exam'
