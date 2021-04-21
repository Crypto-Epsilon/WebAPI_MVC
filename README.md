# WebAPI_MVC

Pets_Tinder API
API to store ane retrieve the data of our pets

Routes
All routes return Json

GET /: Root route shows if Web API is running
GET api/v1/pets/: returns all confiugration IDs
GET api/v1/pets/[ID]: returns details about a single document with given ID
POST api/v1/pets/: creates a new document

Install
Install this API by cloning the relevant branch and installing required gems from Gemfile.lock:

bundle install

Test
Run the test script:

ruby spec/api_spec.rb

Execute
Run this API using:

rackup
