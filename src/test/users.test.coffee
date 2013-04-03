# Codes you should look at: 
#
# * [users.test.coffee](https://github.com/conancat/node-test-examples/blob/master/src/test/users.test.coffee)

# Related pages: 
#
# * [Function code](http://conancat.github.com/node-test-examples/users.html)

# ## Setting up

# *IMPORTANT*: Set your environment as testing, and have environment specific 
# configurations. You DON'T want to mess with your production database while
# you're working on testing! To see how we setup environment specific configurations, 
# check out our [configuration file](http://conancat.github.com/node-test-examples/conf.html).

process.env.NODE_ENV = "testing"

# Here we're declaring some variables that we're gonna use. 
# 
# * Use Chai module for assertion. We'll be using the [`expect`](http://chaijs.com/guide/styles/) interface here.  
# * Get the test helper functions
# * Get the main module that we'll be testing `users`
# * Require the database model so that we can make calls from our test to the database
# to make sure things are being properly created

{expect} = require "chai"

testHelpers = require "./testHelpers"

users = require "../lib/users"

{User} = require "../lib/models"

# ## Begin Test

# Note: You'll notice that there are some `done` calls being called here. This is a cool 
# thing about Mocha -- for every test that you write, you can use the `done` call to specify
# that it is an asynchronous code, and will only be completed after you call the `done` function. 
# If no `done` is passed, then it will assume that it's a synchronous test. 
#
# For more info, check out Mocha's [documentation](http://visionmedia.github.com/mocha/). 


# Before we begin... 
#
# * Clear the database before doing any operations, so that we will not 
# be affected by any old data. 

before (done) ->
  testHelpers.clearDatabase done

# Let's begin the party!

# ### getUser()
# First, we need to populate 
# the database with some mock users. These input are defined in the 
# `mocks/users.json` file which we will require and insert them into the database. 
# Then we can safely test the getUser function if it's working or not. 
# 
# After we're done testing with a perfect input and getting the results that 
# we want, we will test the behaviors of validation as well to see if 
# bad inputs are throwing errors as we will expect them to be. We don't want 
# bad data to go into the database, they will cause trouble later! 

describe "Database test example: Getting data from db", ->
  {getUser} = users

  # Create mock items in database first
  before (done) ->
    mockUsers = require "./mocks/users"
    User.create mockUsers, done

  # Let's test with a normal call, using the name as the argument. 

  it "should get the user by supplying the name in input", (done) ->

    data = 
      name: "Caesar"

    getUser data, (err, result) ->
      expect(result.name).to.be.equal("Caesar")
      done()

  # After that, let's test with the required argument, and an optional argument
  # and see if it is returning the result that we expected. 

  it "should return user that has age specified if specified", (done) ->
    data = 
      name: "Caesar"
      age: 15

    getUser data, (err, result) ->
      expect(result.food).to.be.equal("salad")
      done()

  # The function works perfectly! Now we need to see if we give it some weird input
  # and if it returns the results we wanted. 

  it "should return null if no users are found", (done) ->
    data = 
      name: "Weird ass name"

    getUser data, (err, result) ->
      expect(result).to.be.null
      done()

  it "should return error if no name is specified", (done) ->
    data = 
      age: 10

    getUser data, (err, result) ->
      expect(err).to.be.equal("Name is required")
      done()

# ### createOrUpdateUser()

# For this function, we don't have to 
# create mocks in the database. Instead we call the function directly, 
# check if it returns no error, and we will make a call from the test 
# file to the database and see if the entry is being inserted correctly. 
# 
# We will also make some bad calls to the function on purpose just to see
# if the validations are working correctly when we call the function, 
# so that no jackasses will pass in some weird input and it screws up 
# our database entries. We don't like screwed up databases, do we? 

describe "Database test example: Creating or updating data in db", ->

  {createOrUpdateUser} = users

  # The perfect scenario! Let's make a call to the API, see if returns no 
  # errors, and then we check the database if things are being saved correctly
  
  it "should create user successfully given a perfect input", (done) ->

    data = 
      name: "Grey"
      age: 10
      food: "banana"

    createOrUpdateUser data, (err) ->

      expect(err).to.be.null

      User.findOne name: data.name, (err, result) ->
        expect(result).to.be.an("object")
        done()

  # Let's test the validation function if the function returns
  # errors correctly if we pass in some bad inputs

  it "should throw error if missing name in input", (done) ->
    data = 
      age: 10
      food: "banana"

    createOrUpdateUser data, (err) ->
      expect(err).to.be.equal("Name is required")
      done()

  it "should throw error if missing age in input", (done) ->
    data = 
      name: "Grey"
      food: "banana"

    createOrUpdateUser data, (err) ->
      expect(err).to.be.equal("Age is required")
      done()

  it "should throw error if age is not a number", (done) ->
    data = 
      name: "Grey"
      age: "donkey"
      food: "banana"

    createOrUpdateUser data, (err) ->
      expect(err).to.be.equal("Age must be a number")
      done()


# After we're done...
#
# Clear the database again, and stop the server from running. We're being clean, you know?

after (done) ->
  testHelpers.clearDatabase done



