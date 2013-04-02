
# Validates if input is number
validateAge = (input) ->
  return !isNaN(parseFloat(input)) && isFinite(input);

# Export the modules
module.exports = 
  validateAge: validateAge


