require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'rack/test'
require './app'
require './dummy_data'

class LnkrrAppTests < Minitest::Test
  include Rack::Test::Methods

  def app
    LnkrrApp
  end

  def setup
    User.delete_all
    Link.delete_all
  end

  def auth user="test"
    header "Authorization", user
  end

  def post_link link
    post_request "/testuser/newlinks", body: link
  end

  def create_user user
    User.create! **(user)
  end

  def create_link link
    Link.create! **(link)
  end

  def parse_body response
    JSON.parse response.body
  end

  def test_can_create_links
    auth "skydaddy"
    r = post "/skydaddy/newlinks", apple.to_json
    assert_equal 200, r.status
    binding.pry
  end

  def test_can_view_links
    create_link wikipedia
    create_link apple
    create_link github

    auth "skydaddy"
    r = get "/skydaddy/links"
    body = parse_body r
    assert_equal 200, r.status
    assert a.count > 0
  end
focus
  def test_can_view_user
    create_user storm_trooper1
    create_user storm_trooper2

    auth "skydaddy"
    r = get "/rad_Steve"
    binding.pry
    body = parse_body r
    assert_equal storm_trooper1[:username], body["username"]
    assert_equal 200, r.status
  end
  # def test_can_create_links
  #   u = make_user

  #   header "Authorization", "skydaddy"
  #   resp = post "/skydaddy/newlinks", title: "new link"

  #   assert_equal 200, resp.status
  #   assert_equal 1, Link.count

  #   link = Link.last
  #   assert_equal "new link", link.title
  #   assert_equal u, link.user
  # end

  def test_can_delete_links
    u = make_user
    l = make_link

    assert_equal 0, Link.count
    make_link
    header "Authorization", "skydaddy"
    resp = delete "/#{u.username}/links/#{l.id}"

    assert_equal 200, resp.status
  end
end
