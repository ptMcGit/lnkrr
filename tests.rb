require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'rack/test'
require './app'

class LnkrrAppTests < Minitest::Test
  include Rack::Test::Methods

  def app
    LnkrrApp
  end

  def setup
    User.delete_all
    List.delete_all
  end

  def make_user
    User.create! username: "skydaddy", first_name: "Luke", last_name: "Skywalker", password: "lightsaber"
  end

  def make_link
    Link.create! title: "Test Link", url: "http://www.test.com", description: "This is a test"
  end

  def test_can_create_links
    u = make_user

    header "Authorization", "skydaddy"
    resp = post "/skydaddy/newlinks", title: "new link"

    assert_equal 200, resp.status
    assert_equal 1, Link.count

    link = Link.last
    assert_equal "new link", link.title
    assert_equal u, link.user
  end

  def test_can_delete_links
    u = make_user
    l = make_link

    assert_equal 0, Link.count
    make_link
    header "Authorization", "skydaddy"
    resp = delete "/#{u.username}/links/#{l.id}"

    assert_equal 200, resp.status
  end
binding.pry
end
