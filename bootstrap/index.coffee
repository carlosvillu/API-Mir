{ readdir } = require 'fs'

console.log "Init system:"
readdir "#{__dirname}", (err, files) ->
  for file in files when file isnt "index.coffee"
    do(file) ->
      console.log "Init Module #{file.split('.')[0]}"
      exports[file.split('.')[0]] = require "./#{file}"
