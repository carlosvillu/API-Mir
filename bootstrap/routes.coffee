{ readdir } = require 'fs'
app = require './../app'

routesDir = "#{__dirname}/../routes"

readdir routesDir, (err, files) ->
  for file in files when file isnt "index.coffee"
    do(file) ->
      console.log "Init  Route #{file.split('.')[0]}..."
      require("#{routesDir}/#{file}")(app)

