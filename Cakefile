{spawn, exec} = require 'child_process'
{writeFileSync} = require 'fs'

runCommand = (name, args, options) ->
  proc = spawn name, args, options
  proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
  proc.stdout.on 'data', (buffer) -> console.log buffer.toString()
  proc.on 'exit', (status) -> process.exit(1) if status isnt 0


def = require './config/default.json'

option '-h', '--db-host [HOST]', 'Host to the BD'
option '-p', '--db-port [port]', 'port to the BD'
option '-d', '--db-database [DATABASE]', 'port to the BD'
option '-e', '--env [ENVIROTMENT]', 'Execute env'
option '-u', '--user [USER]', 'Database user'
option '-s', '--pass [PASSWORD]', 'Database pass'

task 'config:env', 'create testing env', (options) ->

  config =
    db:
      'host': options['db-host'] or def.db.host
      'port': options['db-port'] or def.db.port
      'database': options['db-database'] or def.db.database
      'user': options.user
      'pass': options.pass

  writeFileSync "#{__dirname}/config/#{options.env}.json", JSON.stringify(config)

task 'start', 'start server', (options) ->
  process.env['NODE_ENV'] = options.env or 'development'

  runCommand 'nodemon', ['server.js']

task 'test', 'Run all tests', (options) ->
  process.env['NODE_ENV'] = options.env or 'test'
  runCommand './node_modules/mocha/bin/mocha', ['--compilers', 'coffee:coffee-script']
