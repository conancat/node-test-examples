# IMPORTANT: Set environment as testing
process.env.NODE_ENV = "testing"

# Use Chai's expect for assertion
{expect} = require "chai"

# some test helper functions
testHelpers = require "./testHelpers"

# use Phantom for API testing
phantom = require "phantom"

# some variables
server = {} # One server instance
ph = {} # One PhantomJS instance

# Store the server path returned from starting a server instance
serverPath = ""

# SETUP
# Start server before testing
before (done) ->
  @timeout 10000

  testHelpers.startServer (err, result) ->
    if err then return done err

    serverPath = result

    # Create the phantomJS instance
    phantom.create (phantomInstance) ->
      ph = phantomInstance
      done()

# BEGIN TEST
# Start a browser session with a perfect input
describe "Homepage test", ->

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

# Submit form
describe "Submit form", ->
  page = {}

  before (done) ->
    @timeout 10000

    # Emulate the process of submitting a form
    ph.createPage (p) ->
      page = p

      page.open serverPath, (status) ->

        # After page submit, set process as done
        page.set "onLoadFinished", (status) ->
          done()

        # Fill up the form and submit form
        page.evaluate ->

          nameInput = document.getElementById("input-name")
          nameInput.value = "Caesar"

          ageInput = document.getElementById("input-age")
          ageInput.value = 15

          foodInput = document.getElementById("input-food")
          foodInput.value = "salad"

          document.form.submit()

        , ->
          return # Don't do anything here
 
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


# Kill the server and PhantomJS instance after done
after (done) ->
  testHelpers.clearDatabase ->
    ph.exit()
    testHelpers.stopServer serverPath, ->
      done()

