# IMPORTANT: Set environment as testing
process.env.NODE_ENV = "testing"

# Use Chai's expect for assertion
{expect} = require "chai"

# Require the module
helpers = require "../lib/helpers"

# Describe the test 
describe "Module testing example: Input validation", ->

  # Import the function
  {validateAge} = helpers

  # Run the test cases
  it "should return true if valid age is given", ->
    val = validateAge(10)
    expect(val).to.be.true

  it "should return false if given a pure string", ->
    val = validateAge("donkey")
    expect(val).to.be.false

  it "should return false if given a number + string combination", ->
    val = validateAge("10 years old")
    expect(val).to.be.false

  it "should run 10000 iterations successfully", (done) ->
    for i in [0...10000]
      val = validateAge(10)
      expect(val).to.be.true

    done()
