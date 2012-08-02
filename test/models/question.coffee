app = require '../../app'
request = require '../helpers/http'
should = require 'should'
async = require 'async'
Question = null

# Bootstraping must be finished
process.nextTick ->
  Question = require('../../models/question').Model

fixtures =
  question: require '../fixtures/question'

describe 'Question CRUD', ->
  beforeEach (done)->
    async.series
      delete: (cb)->
        Question.remove {}, cb
    , (err, results)->
        done(err)

  it 'Create a question', (done)->
    async.series
      create: (cb)->
        question = new Question(fixtures.question)
        question.save(cb)
      count:(cb)->
        Question.count {}, cb
    , (err, results)->
        results.count.should.be.eql 1
        results.create[1].should.be.eql 1
        results.create[0].should.have.property '_id'
        results.create[0].should.have.property('text').and.be.eql 'Question One'
        results.create[0].answers.should.have.length 3
        done err

  it 'remove a Question', (done) ->
    async.series
      create: (cb)->
        question = new Question(fixtures.question)
        question.save(cb)
      countPre:(cb)->
        Question.count {}, cb
      delete: (cb)->
        Question.remove {}, cb
      countPost:(cb)->
        Question.count {}, cb
    , (err, results)->
        results.countPost.should.be.eql 0
        done err

  it 'Update a question', (done)->
    questionFix = fixtures.question
    async.series
      create: (cb)->
        question = new Question(fixtures.question)
        question.save(cb)
      update: (cb)->
        answers = [ text: 'Update text!', correct: false ]
        Question.update {text: 'Question One'}, {answers: answers}, cb
      search: (cb)->
        Question.find().$where("this.answers[0].text === 'Update text!'").exec(cb)
    , (err, results)->
        results.search.should.have.length 1
        done err
