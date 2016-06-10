require "pry"
require "sinatra/base"
require "sinatra/json"

require "./db/setup"
require "./lib/all"

class LnkrrApp < Sinatra::Base
  set :logging, true
  set :show_exceptions, false

  error do |e|
    binding.pry
  end

  before do
    require_authorization!
  end

  get "/:user/links" do
    get_links
  end

  def get_links
    Link.all.to_json
    #json user.links
  end

  delete "/:user/links/:link_id" do
    username = params[:user]
    del_link = params[:link_id].to_i
    # User.where(username: username).pluck(:owned_links) How do we check ownership of link_id
    Link.find(del_link).delete
    status 200
  end

  get "/:user" do
    sought_user = path[0]
    json User.find_by(username: sought_user)
  end

  # create links

  post "/:user/newlinks" do
    if username_is_path?
      post_new_link params[:user]
    else
      recommend_link
    end
  end

  def post_new_link user
    Link.create! parsed_body
    message(user,Link.last.url)
  end

  # def user
  #   username = request.env["HTTP_AUTHORIZATION"]
  #   if username
  #     #  what if this is a new user? We don't have a password
  #     User.where(username: username).first_or_create!
  #   else
  #     halt 401
  #   end
  # end

  def parsed_body
     begin
       @parsed_body ||= JSON.parse request.body.read
     rescue
       # FIXME
       halt 400
     end
  end

  def require_authorization!
    unless username
      halt(
        401,
        json("status": "error", "error": "You must log in.")
      )
    end
  end

  def username
    request.env["HTTP_AUTHORIZATION"]
  end

  def username_is_path?
    username == path[0]
  end

  def path
    request.env["PATH_INFO"].split("/").drop 1
  end

  def message(user,link)
    token = ENV["SLACK_PAYLOAD"]
    HTTParty.post("#{token}",
      :body => { :username => 'lnkrrbot',
                 :channel => '@tythompson',
                 :text => "#{user} recommended the link: #{link}",
               }.to_json,
      :headers => { 'Content-Type' => 'application/json' } )
  end
  #format is message("user","link")
end

if $PROGRAM_NAME == __FILE__
  LnkrrApp.run!
end
