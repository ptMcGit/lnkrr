require 'pry'
require 'httparty'
require "./db/setup"
require "./lib/all"

def get_request path, auth="webconsole"
  HTTParty.get Url + path, headers: { "Authorization" => auth }
end

def post_request path, auth="webconsole"
  HTTParty.post Url + path, headers: { "Authorization" => auth }
end

Heroku  = "https://lnkrr.herokuapp.com"
Local   = "http://localhost:4567"
Url     = Local
# get_request PATH [AUTHORIZATION_NAME]
# post_request PATH [AUTHORIZATION_NAME]
binding.pry
