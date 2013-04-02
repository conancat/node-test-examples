# Module requires
mongoose = require "mongoose"
{Schema} = mongoose
conf = require "./conf"

# Connect to the database
mongoose.connect conf.db

# Create the schema
userSchema = new Schema
  name: String
  age: Number
  food: String

# Create the models
User = mongoose.model 'User', userSchema

# Export the schema
module.exports = 
  User: User
