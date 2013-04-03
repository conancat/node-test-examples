# Codes you should look at: 
#
# * [users.coffee](https://github.com/conancat/node-test-examples/blob/master/src/lib/users.coffee)

# Related pages: 
#
# * [Test code](http://conancat.github.com/node-test-examples/users.test.html)


# ## Setup

# Lets get the schema from our Models definition
{User} = require "./models"

# ...and get the function that we'll be using throughout our code
{validateAge} = require "./helpers"

# ## The Functions

# ### getUser(data, callback)

#     @params 
#         name(String)  Name of the user that we want to query, Required
#         age(Number)   Age of the user that we want to query. Optional

#     @returns
#         The User object found in the database

getUser = (data, callback) ->

  # First we validate if the input is complete. If it's not, callback error
  if not data.name 
    return callback "Name is required"

  # Create our query, specifiying the name as a required field. 
  # We also specify that if the input contains age, then we'll 
  # use that as an argument to query as well

  # For more information about how MongoDB queries work, check this out

  # * http://docs.mongodb.org/manual/reference/method/db.collection.findOne/
  # * http://mongoosejs.com/docs/queries.html

  query = User.findOne {}

  query.where "name", data.name
  
  if data.age
    query.where "age", data.age

  # Execute the query and return the results directly
  query.exec callback



# ### createOrUpdateUser(data, callback)

#     @params 
#         name(String)  Name of the user that we want to create, required
#         age(Number)   Age of the user that we want to create, required

#     @returns
#         The User object found in the database

createOrUpdateUser = (data, callback) ->
  
  # First we validate if the input is complete. If it's not, callback error
  if not data.name
    return callback "Name is required"

  if not data.age
    return callback "Age is required"

  if not validateAge(data.age)
    return callback "Age must be a number"

  # We fire a query to the database to update the existing user's entry if 
  # it exists, if it doesn't we'll create a new entry. For more information 
  # about how update() works in MongoDB, check this out. 

  # * http://docs.mongodb.org/manual/reference/method/db.collection.update/
  # * http://mongoosejs.com/docs/2.7.x/docs/updating-documents.html

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

# ## Module exports
module.exports = 
  getUser: getUser
  createOrUpdateUser: createOrUpdateUser
