# Some system modules
path = require "path"
child_process = require "child_process"

# Get the models to clear database
models = require "../lib/models"

# Some variables
servers = {}

# Creates the server, returns the server as the result
startServer = (callback) ->
  # Randomly generate a port
  process.env.PORT = Math.max(1000, 10000 - Math.round(Math.random() * 10000))

  # Server path
  filepath = path.resolve path.dirname(module.filename), "../app"

  # Spawn the server process
  server = child_process.spawn "node", [filepath]

  # log output data
  server.stdout.on "data", (data) ->
    str = data.toString()

    # If server is started, consider the setup as done
    if /listening on/.test(str) 
      serverPath = str.split(" ").pop().trim()

      # Cache the server in the list of servers started
      servers[serverPath] = server

      callback null, serverPath

  # Log error data
  server.stderr.on "data", (data) ->

    str = data.toString()

    console.error str

    callback str

# Kill the server
stopServer = (serverPath, callback) ->

  if servers[serverPath]
    server = servers[serverPath]
    server.on 'exit', ->
      callback null

    server.kill()

  else
    callback null

# Clear the database
clearDatabase = (callback) ->
  i = 0
  dbs = []

  # Get a list of dbs
  for key, val of models
    dbs.push val

  # Clear the databases
  clear = ->
    if not dbs[i] then return callback null

    dbs[i].remove (err) ->
      if err then console.error err
      i++
      clear()

  clear()

module.exports = 
  startServer: startServer
  stopServer: stopServer
  clearDatabase: clearDatabase


