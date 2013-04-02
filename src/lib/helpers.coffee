
# Our very simple function here. What it does is just takes an input, 
# and returns true if it's a valid age (number), and returns false if it's not.

validateAge = (input) ->
  return !isNaN(parseFloat(input)) && isFinite(input);

# Export the module as usual
module.exports = 
  validateAge: validateAge


