# Codes you should look at: 
#
# * [browser.test.coffee](https://github.com/conancat/node-test-examples/blob/master/src/test/browser.test.coffee)

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
# * Require Phantom for API testing
# * Setup some placeholder variables

{expect} = require "chai"

testHelpers = require "./testHelpers"

phantom = require "phantom"

server = {}
ph = {}

serverPath = ""


# ## Begin Test

# Note: You'll notice that there are some `done` calls being called here. This is a cool 
# thing about Mocha -- for every test that you write, you can use the `done` call to specify
# that it is an asynchronous code, and will only be completed after you call the `done` function. 
# If no `done` is passed, then it will assume that it's a synchronous test. 
#
# For more info, check out Mocha's [documentation](http://visionmedia.github.com/mocha/). 


# Before we begin... 
#
# Before we begin, let's clear the database to get rid of any old data, 
# and start the server in our test. Our startServer() function returns the 
# serverPath which we will use to make test API calls to later. 
#
# In this page we're also doing an extra step, which is to initialize our 
# little Phantom instance so that we can use the same Phantom throughout our test later. 
#
# To understand more about what our doing here, 
# check out the [testHelpers](http://conancat.github.com/node-test-examples/testHelpers.html) page. 

before (done) ->
  @timeout 10000

  testHelpers.startServer (err, result) ->
    if err then return done err

    serverPath = result

    phantom.create (phantomInstance) ->
      ph = phantomInstance
      done()

# ## Begin Test

# ### Open the homepage
# 
# Well this is a really simple one. We call our Phantom to open our homepage, and see 
# if it correctly opened the page, and see if some page elements are there, such as 
# the three input boxes and a submit button. Hah. 

describe "Headless Browser test example: Open homepage", ->

  page = {}

  before (done) ->
    ph.createPage (p) ->
      p.open serverPath, (status) ->
        page = p
        done()

  it "should be able to open page successfully with correct page title", (done) ->
    page.evaluate (-> document.title), (result) ->
      expect(result).to.be.equal("Hello there!")
      done()

  it "should contain 3 input boxes", (done) ->
    page.evaluate -> 
      inputs = document.querySelectorAll("input[type=text]")
      return inputs.length
    , (result) ->
      expect(result).to.be.equal(3)
      done()

  it "should contain a submit button", (done) ->
    page.evaluate ->
      submit = document.querySelectorAll("input[type=submit]")
      return submit.length
    , (result) ->
      expect(result).to.be.equal(1)
      done()

# ### Submit form
#
# This one is slightly tougher. We're going to fill up the form elements
# on the page with some mock data, and when we're done, we will submit the form, 
# wait for the next page to load, and run tests on the results page. 

# So what's the process?

# Over here, we're telling our Phantom to load the homepage. 
# Once it's done loading, we add a callback
# to Phantom telling that "Hey, the next page you load, when you're finished, 
# let's call this done". Then we proceed to fill up the form with plain ol
# browser side Javascript with the page.evaluate() function, then submit the form
# programmatically. We skip the callback after the Javascript evaluation by doing
# an empty `return`. 
# 
# Then when the page is loaded, we run tests against the second page
# being returned, and it should be as expected. Yeahhh, Caesar salad! 

describe "Headless browser test example: Submitting a form", ->
  page = {}

  before (done) ->
    @timeout 10000

    ph.createPage (p) ->
      page = p

      page.open serverPath, (status) ->

        page.set "onLoadFinished", (status) ->
          done()

        page.evaluate ->

          nameInput = document.getElementById("input-name")
          nameInput.value = "Caesar"

          ageInput = document.getElementById("input-age")
          ageInput.value = 15

          foodInput = document.getElementById("input-food")
          foodInput.value = "salad"

          document.form.submit()

        , ->
          return
 
  it "should say Hello Caesar at the next page", (done) ->
    page.evaluate ->
      title = document.querySelector("h1")
      return title.innerText
    , (result) ->
      expect(result).to.be.equal("Hello Caesar!")
      done()

  it "should show Caesar's name and age and favorite food", (done) ->
    page.evaluate ->
      result = document.querySelector(".result")
      return result.innerText
    , (result) ->
      expect(result).to.be.equal("Now I know that your name is Caesar, your age is 15 and your favorite food is salad.")
      done()


# After we're done...
#
# Clear the database again, and stop the server from running. We're being clean, you know?

after (done) ->
  testHelpers.clearDatabase ->
    ph.exit()
    testHelpers.stopServer serverPath, ->
      done()

