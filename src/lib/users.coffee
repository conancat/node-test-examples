# Get the schema
{User} = require "./models"
{validateAge} = require "./helpers"

getUser = (data, callback) ->
  if not data.name 
    return callback "Name required"

  query = User.findOne {}

  query.where "name", data.name
  
  if data.age
    query.where "age", data.age

  query.exec callback

createOrUpdateUser = (data, callback) ->
  
  # Validate input
  if not data.name
    return callback "Name is required"

  if not data.age
    return callback "Age is required"

  if not validateAge(data.age)
    return callback "Age must be a number"

  # Create or update the user
  User.update
    name: data.name
    age: data.age
  , 
    name: data.name
    age: data.age
    food: data.food
  , 
    upsert: true
  , 
    callback

# Export the functions
module.exports = 
  getUser: getUser
  createOrUpdateUser: createOrUpdateUser
