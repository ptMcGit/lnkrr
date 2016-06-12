ENV["TEST"] = "true"

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
    Slink.delete_all
  end

  def auth user="test"
    header "Authorization", user
  end

  def post_link link
    post_request "/testuser/newlinks", body: link
  end

#skydaddy, skygranddaddy, storm_trooper1
  def create_user user
    User.create! **(user)
  end

#github, apple, wikipedia
  def create_link link
    Link.create! **(link)
  end

  def create_slink submitter, link, receiver
    Slink.create!(user_id: submitter.id, link_id: link.id, receiver_id: receiver.id)
  end

  def parse_body response
    JSON.parse response.body
  end

### README tests

  def test_can_POST_links_to_self
    User.create! skydaddy
    auth "skydaddy:lightsaber"
    r = post "/skydaddy/links", apple.to_json

    assert last_response.ok?
    assert_equal 1, Link.count
  end

  def test_can_GET_links
    s = User.create! skydaddy
    l = Link.create! wikipedia
    r = User.create! skygranddaddy

    create_slink s, l, r

    auth "skydaddy:lightsaber"
    r = get "/skydaddy/links"

    body = parse_body r
    assert last_response.ok?
    assert_equal "Wikipedia", body[0]["title"]
  end

  def test_can_view_user
    u = User.create! skydaddy
    s1 = User.create! storm_trooper1
    s2 = User.create! storm_trooper2

    auth "skydaddy:lightsaber"
    r = get "/rad_Steve"
    body = parse_body r

    assert_equal s1.username, body["username"]
    assert last_response.ok?
  end

  def test_can_delete_links
    assert_equal 0, Link.count
    u = User.create! skydaddy
    l = Link.create! github

    assert_equal 1, Link.count

    auth "skydaddy:lightsaber"

    r = delete "/skydaddy/links/#{l.id}"
    assert_equal 0, Link.count
    assert last_response.ok?
  end

  def test_can_recommend_links_to_other
    s = User.create! skydaddy
    r = User.create! skygranddaddy

    auth "skydaddy:lightsaber"
    resp = post "/skygranddaddy/recommended", wikipedia.to_json
    l = Link.find_by(title: "Wikipedia")
    sl = Slink.first

    assert last_response.ok?
    assert_equal [sl.user_id, sl.link_id, sl.receiver_id], [s.id, l.id, r.id]
    assert_equal 1, Slink.count
  end

  def test_can_view_recommended_links
    s = User.create! storm_trooper2
    l = Link.create! github
    r = User.create! storm_trooper3
    create_slink s, l, r

    auth "swellPhil:dat77"
    resp = get "/MojoMike/recommended"

    body = parse_body resp

    assert last_response.ok?
    assert_equal "GitHub", body[0]["title"]
    assert_equal 1, body.count
  end

  ### ^ README TESTS

  def test_cant_recommend_to_nonexistent_user

    s = User.create! skydaddy

    auth "skydaddy:lightsaber"
    r = post "/billy/recommended", wikipedia.to_json
    l = Link.find_by(title: "Wikipedia")
    sl = Slink.first

    assert_equal r.status, 404
    assert_equal 0, Slink.count
  end

  def test_cant_post_to_someone_elses_links

     u1 = User.create! storm_trooper2
     u2 = User.create! storm_trooper3

     auth "swellPhil:dat77"
     r = post "/MojoMike/links"
     body = parse_body r

     assert_equal r.status, 404
  end

  def test_cant_post_duplicate_links
    u = User.create! skydaddy

    auth "skydaddy:lightsaber"
    post "/skydaddy/links", github.to_json
    r = post "/skydaddy/links", github.to_json

    assert last_response.ok?
    assert_equal 1, Link.count
  end
end
