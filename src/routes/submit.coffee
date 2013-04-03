# Codes you should look at: 
#
# * [submit.coffee](https://github.com/conancat/node-test-examples/blob/master/src/routes/home.coffee)
# * [index.jade](https://github.com/conancat/node-test-examples/blob/master/views/index.jade)

# Just some simple module require!
users = require "../lib/users"


# Over here we try to make the call to the createOrUpdateUser() function
# with the raw data from the POST request. If there is an error, we'll need to 
# return the error to the client side. 
#
# Note that we are returning different formats of result based on the 
# call type. If it's a XHR request (`req.xhr`) then we will return a JSON
# style result with the `res.send` call. If not, we're returning a normal
# HTTP page, which we create through a `res.render` call. 

module.exports = (req, res, next) ->
  
  error = ""

  users.createOrUpdateUser req.body, (err) ->
    if err
      if req.xhr 
        res.send 400, 
          meta: 
            status: 400
            msg: err
      else
        res.render "index",
          title: "Oops!"
          error: err
    else
      if req.xhr
        res.send 200,
          meta:
            status: 200
            msg: "ok"
      else
        res.render "complete",
          title: "Hello #{req.body.name}!"
          error: ""
          user: req.body