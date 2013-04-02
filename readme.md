# NodeJS Tests Example

This project is an example project to demonstrate how to write tests in NodeJS. We will look at how to: 

* Test regular NodeJS modules
* Test interactions with the database
* Test API requests 
* Headless browser testing on the server side (with [PhantomJS](http://phantomjs.org/))

This project serves as an introduction to testing with NodeJS. If you're a beginner to NodeJS, new to writing tests, or just checking things out, have fun and let me know what you think! 

Check out the project's [documentation page](http://node-test-examples.github.com)! 

If you have any questions, you can also find me on [Twitter](http://twitter.com/conancat) or email me at conancat@gmail.com. 

## Tools that we'll need

* [Mocha](http://visionmedia.github.com/mocha/), our testing framework of choice
* [Chai](http://chaijs.com/) as our assertion library
* [PhantomJS](http://phantomjs.org/) as our ghostly, headless browser testing tool

And of course, I'd assume that you already have some prior experience with awesome tools like [Express](http://expressjs.com/), [Request](https://github.com/mikeal/request), [Async](https://github.com/caolan/async) and so forth. If you haven't, go check it out! 

This project is written in [CoffeeScript](http://coffeescript.org/), but the concepts presented are absolutely the same with what you're going to do with JavaScript. As long as you understand what's happening, you can apply it anywhere! 

## Setting up 

First thing first, setting up this repo is easy as ABC. 

    git clone https://github.com/conancat/node-test-examples.git
    cd node-test-examples
    npm install

Also, you'll need to have Mocha installed as an executable by doing:

    npm install mocha -g

You'll also need to install PhantomJS in order for the browser tests to work. You can follow the instructions on (installing PhantomJS)[http://phantomjs.org/download.html] here. 

## Running the app

At the root of the folder, type

    node app.js

Then you can go to `http://localhost:3000` to see what the app does. Yeah, we're gonna test the hell outta this simple app that asks for your name, your age and your favorite food! 

## Running the tests

At the root folder of this project, type

    mocha

Then the tests should run. Yay! If you want a more verbose version of the test results, you can type this instead: 

    mocha -R spec

## Documentation

There are five different parts of this exercise. You can look at the documentation, and comparing the actual code as well as the test cases! 

### Simple function testing

This is a straightforward one. We'll just take a simple function and test the hell outta it. Hey, you always want to make sure the code you wrote works!

* [Function code](http://node-test-examples.github.com/helpers.html)
* [Test code](http://node-test-examples.github.com/helpers.test.html)

### Database testing

We have two simple functions that interact with the database -- `get` and `createOrUpdate`. Let's setup and create mocks, run tests to make sure things are working properly, and nicely clean things up after we're done.

* [Function code](http://node-test-examples.github.com/users.html)
* [Test code](http://node-test-examples.github.com/users.test.html)

### API Testing

So we have REST api and we want to make sure it works. Let's start a server, make calls to it and check if it returns the desired results!

* [Function code](http://node-test-examples.github.com/submit.html)
* [Test code](http://node-test-examples.github.com/api.test.html)

### Headless Browser Testing

Sometimes it's too slow to need to open every single page on your website every single time you want to deploy a site, just to see if everything is working. Let's start a server, get a headless zombie ghost phantom tester thing to go through the site and see if things are working! 

* [Test code](http://node-test-examples.github.com/browser.test.html)

Remember to start the server yourself at least once to go through and see what's happening on the site, before we try to emulate things with our little phantom!


## Test results

For your reference only! 

      API test example: POST /submit
        Perfect input
          ✓ should return a JSON object
          ✓ should contain the meta data
          ✓ should return status of 200
          ✓ should return 'ok' message
        Error input
          ✓ should return a JSON object
          ✓ should contain the meta data
          ✓ should return status of 403
          ✓ should return error message saying 'Age must be a number'

      Headless Browser test example: Open homepage
        ✓ should be able to open page successfully with correct page title
        ✓ should contain 3 input boxes
        ✓ should contain a submit button

      Headless browser test example: Submitting a form
        ✓ should say Hello Caesar at the next page
        ✓ should show Caesar's name and age and favorite food

      Module testing example: Input validation
        ✓ should return true if valid age is given
        ✓ should return false if given a pure string
        ✓ should return false if given a number + string combination
        ✓ should run 10000 iterations successfully (52ms)

      Database test example: Getting data from db
        ✓ should get the user by supplying the name in input
        ✓ should return user that has age specified if specified
        ✓ should return null if no users are found

      Database test example: Creating or updating data in db
        ✓ should create user successfully given a perfect input
        ✓ should throw error if missing name in input
        ✓ should throw error if missing age in input
        ✓ should throw error if age is not a number


      24 tests complete (2 seconds)

