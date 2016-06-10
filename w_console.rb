require 'pry'
require 'httparty'
require 'json'
require "./db/setup"
require "./lib/all"
require "./dummy_data"

def get_request path, auth: "webconsole", body: {}
  HTTParty.get Url + path, headers: { "Authorization" => auth }, body: body.to_json
end

def post_request path, auth: "webconsole", body: {}
  HTTParty.post Url + path, headers: { "Authorization" => auth }, body: body.to_json
end

def create_user_test
  User.create!(username:"skydaddy",password:"lightsaber")
end

Heroku  = "https://lnkrr.herokuapp.com"
Local   = "http://localhost:4567"
Url     = Local
# get_request PATH [AUTHORIZATION_NAME]
# post_request PATH [AUTHORIZATION_NAME]
binding.pry
