# Set configurations here
confs = 
  "development": 
    "db": "mongodb://localhost/myapp-dev"

  "testing": 
    "db": "mongodb://localhost/myapp-test"

# Check for the environment
env = process.env.NODE_ENV

# If environment doesnt exist, set it as Development
if not env 
  process.env.NODE_ENV = "development"

# Get the configuration
conf = confs[env]

# If not valid environment, return the development configuration
if not conf
  conf = confs["development"]

# Export the correct configuration settings
module.exports = conf

