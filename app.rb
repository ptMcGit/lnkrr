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
    username = params[:user]

  end

  post "/:user/links" do
    username = params[:user]
    get_links
  end

  def get_links
    Link.all.to_json
    #json user.links
  end

  delete "/:user/links/:link_id" do
    username = params[:user]
    data = User.find_by(username: username)
    del_link = params[:link_id].to_i
    if data == nil
      # username doesn't exist
      status 404
    else
      data.to_json
      status 200
    end
    # User.where(username: username).pluck(:owned_links) How do we check ownership of link_id
    Link.find(del_link).delete
    status 200
  end

  get "/:user" do
    username = params[:user]
    data = User.where(username: username)
    if data == nil
      # username doesn't exist
    else
      data.to_json
    end
  end

  # create links

  post "/:user/newlinks" do
    username = params[:user]
    data = User.find_by(username: username)
    post_new_link params[:user]
    status 200
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
