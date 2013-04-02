# IMPORTANT: Set environment as testing
process.env.NODE_ENV = "testing"

# Use Chai's expect for assertion
{expect} = require "chai"

# some test helper functions
testHelpers = require "./testHelpers"

# use Request for API testing
request = require "request"

# some variables
serverPath = ""

# Clear database and start server before testing
before (done) ->
  @timeout 10000

  testHelpers.clearDatabase ->
    testHelpers.startServer (err, result) ->
      if err then return done err
      serverPath = result
      done()

# Start testing the /submit route
describe "API test example: POST /submit", ->

  # Test with a perfect input
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


  # Test with a faulty input
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
          age: "donkey" # AGE IS WRONG! 
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

# Kill the server after done
after (done) ->
  testHelpers.clearDatabase ->
    testHelpers.stopServer serverPath, ->
      done()

