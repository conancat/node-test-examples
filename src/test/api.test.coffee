# Codes you should look at: 
#
# * [helpers.test.coffee](https://github.com/conancat/node-test-examples/blob/master/src/test/api.test.coffee)

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
# * Use Chai's expect for assertion
# * Get the test helper functions
# * Get the Request package for API testing
# * Setup some placeholder variables

{expect} = require "chai"

testHelpers = require "./testHelpers"

request = require "request"

serverPath = ""

# ## Begin Test

# Before we begin, let's clear the database to get rid of any old data, 
# and start the server in our test. Our startServer() function returns the 
# serverPath which we will use to make test API calls to later. 
#
# To understand more about how our helpers are doing this, 
# check out the [testHelpers](http://conancat.github.com/node-test-examples/testHelpers.html) oage. 

before (done) ->
  @timeout 10000

  testHelpers.clearDatabase ->
    testHelpers.startServer (err, result) ->
      if err then return done err
      serverPath = result
      done()

# For this test, we're doing a call to our POST /submit route. We fired up our server, 
# and with the Request module we POST some requests to see if it's returning the desired results. 
# We check if it is returning a JSON result, and if the parts of the result are correct. 
# 
# In short, our process is: 
#
# Perfect Input
# * Make a call to POST `http://localhost:<port>/submit&name=<name>&age=<age>&food=<food>`
# * Should return `{"meta":{"status":200, "msg":"ok"}}`
#
# Error input
# * Make a call to `POST http://localhost:<port>/submit&name=<name>&age=<wrong age>&food=<food>`
# * Should return `{"meta": {"status": 400, "msg": "Error message"}}`
#
# First let's create a suite...

describe "API test example: POST /submit", ->

  # Test with a perfect input. Oh yeah!

  describe "Perfect input", ->
    response = {}

    before (done) ->
      endpoint = serverPath + "/submit"

      request.post endpoint,
        headers:
          "X-Requested-With": "XMLHttpRequest"
        json: true
        form:
          name: "Caesar"
          age: 13
          food: "sandwich"
      , (err, res, body) ->
        response = body
        done()

    it "should return a JSON object", ->
      expect(response).to.be.an("object")

    it "should contain the meta data", ->
      expect(response.meta).to.be.an("object")

    it "should return status of 200", ->
      expect(response.meta.status).to.be.equal(200)

    it "should return 'ok' message", ->
      expect(response.meta.msg).to.be.equal("ok")


  # Test with a faulty input. We're entering a wrong AGE! 
  describe "Error input", ->
    response = {}

    before (done) ->
      endpoint = serverPath + "/submit"

      request.post endpoint,
        headers:
          "X-Requested-With": "XMLHttpRequest"
        json: true
        form:
          name: "Caesar"
          age: "donkey" 
          food: "sandwich"
      , (err, res, body) ->
        response = body
        done()

    it "should return a JSON object", ->
      expect(response).to.be.an("object")

    it "should contain the meta data", ->
      expect(response.meta).to.be.an("object")

    it "should return status of 403", ->
      expect(response.meta.status).to.be.equal(400)

    it "should return error message saying 'Age must be a number'", ->
      expect(response.meta.msg).to.be.equal("Age must be a number")

# After we're done...
#
# Clear the database again, and stop the server from running. We're being clean, you know?

after (done) ->
  testHelpers.clearDatabase ->
    testHelpers.stopServer serverPath, ->
      done()

