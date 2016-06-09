require 'pry'
require 'httparty'

def my_url arg
  Url + arg
end

Heroku  = "https://lnkrr.herokuapp.com"
Local   = "http://localhost:4567"
Url     = Local
# HTTParty.get my_url ...
binding.pry
