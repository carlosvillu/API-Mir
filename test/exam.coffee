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

  describe 'Exam#create', ->
    it 'should be possible create a new exam'

  describe 'Exam#update', ->
    it 'should be posible update an exam'

  describe 'Exam#read', ->
    it 'should be possible read an exam'

  describe 'Exam#delete', ->
    it 'should be possible delete an exam'
