# module requires
users = require "../lib/users"

module.exports = (req, res, next) ->
  
  error = ""

  # Call the create or update user function
  users.createOrUpdateUser req.body, (err) ->

    # Send different type of result based on request type
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