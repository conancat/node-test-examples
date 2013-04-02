# Main server file. Well, nothing much to see here. Let's just move on, shall we? 

# Require modules needed to start server
express = require("express")
http = require("http")
app = express()

# Configure the server
app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + "/public")

app.configure "development", ->
  app.use express.logger("dev")
  app.use express.errorHandler()

# Setup routes
app.get "/", require("./routes/home")
app.post "/submit", require("./routes/submit")

# Setup server. On yeah!
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on http://localhost:" + app.get("port")
