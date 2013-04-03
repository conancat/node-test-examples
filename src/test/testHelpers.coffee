# ## The Setup

# Just getting some modules that we will need and stuff, the usual. 

path = require "path"
child_process = require "child_process"

models = require "../lib/models"

servers = {}


# ## The Functions

# ### startServer()
# 
# Starts a server by spawning a child process, and saving the process
# in the `servers` object so that we can kill it later on. We generate
# a random port on start so that every server started runs on different 
# processes, on different ports, starting a couple of sandboxed tests 
# at the same time. 
#
# Note: In our `app.js` file we've specified that the port to listen to 
# is determinded by our `PORT` env var. Thus we generate
# a different `PORT` every time we start one.
#
#     @returns
#         serverPath    The URL of the server being started, 
#                       so that we can make calls to it

startServer = (callback) ->
  process.env.PORT = Math.max(1001, 10000 - Math.round(Math.random() * 10000))
  filepath = path.resolve path.dirname(module.filename), "../app"
  server = child_process.spawn "node", [filepath]

  # Log the output data.
  # If server is started, consider the setup as done
  # Also cache the server in the `servers` object so 
  # we can kill it later on. 
  #
  # Also log the error data, and callback error if it happens. 

  server.stdout.on "data", (data) ->
    str = data.toString()

    if /listening on/.test(str) 
      serverPath = str.split(" ").pop().trim()
      servers[serverPath] = server
      callback null, serverPath

  server.stderr.on "data", (data) ->
    str = data.toString()
    console.error str
    callback str

# ### stopServer()
# 
# Kills the server, based on the provided server path. 
# If the server exists and running, then kill it. If it's not, 
# meh. We also specify it to callback after server exists, just in case.
stopServer = (serverPath, callback) ->

  if servers[serverPath]
    server = servers[serverPath]
    server.on 'exit', ->
      callback null

    server.kill()

  else
    callback null

# ### clearDatabase()
# 
# This is a MongoDB operation which clears the database, by iterating
# through the models defined in the `models.js` file and clearing 
# each one of them. As clearing the DB is an asynchronous task, a normal 
# `for` loop wouldn't work. We wanna make sure each database is cleared
# before we move on to the next one. 

clearDatabase = (callback) ->
  i = 0
  dbs = []

  for key, val of models
    dbs.push val

  clear = ->
    if not dbs[i] then return callback null

    dbs[i].remove (err) ->
      if err then console.error err
      i++
      clear()

  clear()

# ## Finally

# Just export the functions! 

module.exports = 
  startServer: startServer
  stopServer: stopServer
  clearDatabase: clearDatabase


