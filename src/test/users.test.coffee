# IMPORTANT: Set environment as testing
process.env.NODE_ENV = "testing"

# Require chai
{expect} = require "chai"

# Some test helpers
testHelpers = require "./testHelpers"

# Require lib module
users = require "../lib/users"

# Require the database model
{User} = require "../lib/models"


# Clear the database before doing any operations
before (done) ->
  testHelpers.clearDatabase done

# Test get users function
describe "Database test example: Getting data from db", ->
  {getUser} = users

  # Create mock items in database first
  before (done) ->
    mockUsers = require "./mocks/users"
    User.create mockUsers, done

  # Begin test cases
  it "should get the user by supplying the name in input", (done) ->

    data = 
      name: "Caesar"

    getUser data, (err, result) ->
      expect(result.name).to.be.equal("Caesar")
      done()

  it "should return user that has age specified if specified", (done) ->
    data = 
      name: "Caesar"
      age: 15

    getUser data, (err, result) ->
      expect(result.food).to.be.equal("salad")
      done()

  it "should return null if no users are found", (done) ->
    data = 
      name: "Weird ass name"

    getUser data, (err, result) ->
      expect(result).to.be.null
      done()

# Create or update user
describe "Database test example: Creating or updating data in db", ->

  {createOrUpdateUser} = users

  # The perfect scenario!
  it "should create user successfully given a perfect input", (done) ->

    data = 
      name: "Grey"
      age: 10
      food: "banana"

    createOrUpdateUser data, (err) ->

      # Err should be null, yeah
      expect(err).to.be.null

      User.findOne name: data.name, (err, result) ->
        expect(result).to.be.an("object")
        done()

  # Test validations
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






