# This is simple as hell. We're just setting the page title
# and render the page results. Move along. Nothing to see here. 

# Codes you should look at: 
#
# * [home.coffee](https://github.com/conancat/node-test-examples/blob/master/src/routes/home.coffee)
# * [index.jade](https://github.com/conancat/node-test-examples/blob/master/views/index.jade)

module.exports = (req, res) ->
  res.locals.error = ""
  res.locals.title = "Hello there!"
  res.render "index"

