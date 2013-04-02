module.exports = (req, res) ->
  res.locals.error = ""
  res.locals.title = "Hello there!"
  res.render "index"

