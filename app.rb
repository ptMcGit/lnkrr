require "pry"
require "sinatra/base"
require "sinatra/json"

require "./db/setup"
require "./lib/all"

class LinkrApp < Sinatra::Base
  set :logging, true
  set :show_exceptions, false

  error do |e|
  #   if e.is_a? ActiveRecord::RecordNotFound
  #     halt 404
  #   elsif e.is_a? ActiveRecord::RecordInvalid
  #     # FIXME: why is this 500'ing _after_ sending the JSON response?
  #     json error: e.message
  #   else
  #     # raise e
  #     puts e.message
    #   end
    binding.pry
  end

  get "/:user/links" do
    binding.pry
  #   lists = user.lists
  #   json lists: user.lists.pluck(:title)
    # end
  end

  # get "/lists/:name" do
  #   list = user.lists.where(title: params[:name]).first
  #   json items: list.items
  # end

  # post "/lists/:name" do
  #   list = user.lists.where(title: params[:name]).first
  #   list.add_item parsed_body["name"], due_date: parsed_body["due_date"]

  #   status 200
  # end

  # delete "/items/:id" do
  #   item = user.items.find params[:id]
  #   item.mark_complete
  #   status 200
  # end

  # get "/message/:text" do
  #   params[:text].reverse
  # end

  post "/:user/newlinks" do

    #user.make_list params[:title]
  end

  # def user
  #   username = request.env["HTTP_AUTHORIZATION"]
  #   if username
  #     # FIXME: what if this is a new user? We don't have a password
  #     User.where(username: username).first_or_create!
  #   else
  #     halt 401
  #   end
  # end

  # def parsed_body
  #   begin
  #     @parsed_body ||= JSON.parse request.body.read
  #   rescue
  #     # FIXME
  #     halt 400
  #   end
  # end
end

if $PROGRAM_NAME == __FILE__
  LinkrApp.run!
end
