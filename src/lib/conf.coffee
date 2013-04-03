# ## Why do we need a conf file?

# We want our app to run in different environments. When developing 
# we may have a different set of data, when testing we have another 
# different set of data, which we don't want to interfere with 
# the data we have when running on testing or even production. 
# You definitely DON'T wanna screw up your production or staging 
# data. Keeping all these configuration stuffs in one place
# is going to save you a LOT of trouble setting up again and 
# again later on. 


# So first, let's define our configurations here. This is a simple one, 
# your configurations for our apps might be much more complicated!

confs = 
  "development": 
    "db": "mongodb://localhost/myapp-dev"

  "testing": 
    "db": "mongodb://localhost/myapp-test"

  "staging": 
    "db": "mongodb://localhost/myapp-stag"

  "production": 
    "db": "mongodb://localhost/myapp-prod"


# Then we look for the environment variable as defined in your shell. 
# If it doesn't exist, we default it to "development". 

env = process.env.NODE_ENV || "development"

# Then we try to get the correct environment configuration based on 
# the env variable. If some jackass puts in a dumb env variable 
# and it doesn't exist, meh, let's just return the 
# development configurations. 

conf = confs[env] || confs["development"]


# Finally we export the correct configuration settings

module.exports = conf

