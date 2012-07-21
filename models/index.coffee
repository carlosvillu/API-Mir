{ readdir } = require 'fs'
module.exports = (app) ->
  readdir "#{__dirname}", (err, files) ->
    require("./#{file}")(app) for file in files when file isnt "index.coffee"
