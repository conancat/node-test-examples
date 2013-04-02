# module requires
users = require "../lib/users"

# Homepage
exports.index = (req, res, next) ->

  res.locals.error = ""
  res.locals.title = "Hello there!"
  res.render "index"

# /submit
exports.submit = (req, res, next) ->
  
  error = ""

  # Call the create or update user function
  users.createOrUpdateUser req.body, (err) ->

    # Send different type of result based on request type

    # AJAX request
    if req.xhr
      if err
        res.send 400, 
          meta: 
            status: 400
            msg: err
      else
        res.send 200,
          meta:
            status: 200
            msg: "ok"

    else # HTTP request
      if err
        res.render "index",
          title: "Oops!"
          error: err
      else
        res.render "complete",
          title: "Hello #{req.body.name}!"
          error: ""
          user: req.body

