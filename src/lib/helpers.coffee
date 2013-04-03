# Codes you should look at: 
#
# * [helpers.coffee](https://github.com/conancat/node-test-examples/blob/master/src/lib/helpers.coffee)

# Related pages: 
#
# * [Test code](http://conancat.github.com/node-test-examples/helpers.test.html)

# ## The Function

# Our very simple function here. What it does is just takes an input, 
# and returns true if it's a valid age (number), and returns false if it's not.

validateAge = (input) ->
  return !isNaN(parseFloat(input)) && isFinite(input);

# Export the module as usual
module.exports = 
  validateAge: validateAge


