require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'rack/test'
require './app'

class TodoAppTests < Minitest::Test
  include Rack::Test::Methods

  def app
    TodoApp
  end

  def setup
    User.delete_all
    List.delete_all
    Item.delete_all
  end

  def test_can_create_lists
    u = User.create! username: "floop", password: "password"

    header "Authorization", "floop"
    resp = post "/lists", title: "new list"

    assert_equal 200, resp.status
    assert_equal 1, List.count

    list = List.last
    assert_equal "new list", list.title
    assert_equal u, list.user
  end
end
