module.exports = (app) ->

  # GET /exam/:id
  app.get '/exam/:id', (req, res) ->
    res.send "Exam: #{req.params.id}"
