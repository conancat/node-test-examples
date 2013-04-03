# Codes you should look at: 
#
# * [helpers.test.coffee](https://github.com/conancat/node-test-examples/blob/master/src/test/helpers.test.coffee)

# Related pages: 
#
# * [Function code](http://conancat.github.com/node-test-examples/helpers.html)

# ## Setting up

# *IMPORTANT*: Set your environment as testing, and have environment specific 
# configurations. You DON'T want to mess with your production database while
# you're working on testing! To see how we setup environment specific configurations, 
# check out our [configuration file](http://conancat.github.com/node-test-examples/conf.html).

process.env.NODE_ENV = "testing"

# Here we're declaring some variables that we're gonna use. 
# 
# * Use Chai module for assertion. We'll be using the [`expect`](http://chaijs.com/guide/styles/) interface here. 
# * Require the main module that we'll be using.
 
{expect} = require "chai"

helpers = require "../lib/helpers"


# ## Begin Test

# First we create a group of tests, let's start by describing the test
describe "Module testing example: Input validation", ->

  # Just a quick reference to the function we're testing
  {validateAge} = helpers

  # These tests are straight forward true or false tests that we want
  # to run against our function. We want the result being returned 
  # from the function works exactly like how we want it to be.

  it "should return true if valid age is given", ->
    val = validateAge(10)
    expect(val).to.be.true

  it "should return false if given a pure string", ->
    val = validateAge("donkey")
    expect(val).to.be.false

  it "should return false if given a number + string combination", ->
    val = validateAge("10 years old")
    expect(val).to.be.false

  # In some cases we want to see how well this function is performing. 
  # Yeah, unit tests, baby! Let's run the function 10000 times and see
  # how much times it takes for it to perform. This is good for benchmarking
  # and optimising your code. But most of the time, as a first step, get the functions 
  # right first. 

  it "should run 10000 iterations successfully", ->
    for i in [0...10000]
      val = validateAge(10)
      expect(val).to.be.true
