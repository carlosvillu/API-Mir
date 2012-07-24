app = require '../app'
request = require './helpers/http'
exam = null

# Bootstraping must be finished
process.nextTick ->
  exam = require '../models/exam'

fixtures =
  exam: require './fixtures/exam'


describe 'Model Exam', ->
  it 'should be a exam model', ->

  describe 'Exam#create', ->
    it 'should be possible create a new exam'

  describe 'Exam#update', ->
    it 'should be posible update an exam'

  describe 'Exam#read', ->
    it 'should be possible read an exam'

  describe 'Exam#delete', ->
    it 'should be possible delete an exam'
