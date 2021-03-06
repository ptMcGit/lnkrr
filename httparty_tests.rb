require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require './dummy_data'
require 'httparty'

Heroku  = "https://lnkrr.herokuapp.com"
Local   = "http://localhost:4567"
Ngrok   = "https://4b34ac23.ngrok.io"
Url     = Ngrok

class LnkrrAppTests < Minitest::Test

  def get_request path, auth: "webconsole", body: {}
    HTTParty.get Url + path, headers: { "Authorization" => auth }, body: body.to_json
  end

  def post_request path, auth: "webconsole", body: {}
    HTTParty.post Url + path, headers: { "Authorization" => auth }, body: body.to_json
  end
  focus
  def test_can_view_user
    r = get_request "/skydaddy"
    body = JSON.parse r
    binding.pry
    assert_equal "skydaddy", body[0]["username"]
    assert_equal 1, body.count
    assert_equal 200, r.status
  end



end
