require "pry"
require "sinatra/base"
require "sinatra/json"

require "./db/setup"
require "./lib/all"

class LnkrrApp < Sinatra::Base
  set :logging, true
  set :show_exceptions, false

  error do |e|
  end

  before do
    require_authorization!
  end

#################

  get "/:user/links" do
    param_user = params[:user]
    Slink.where(owner: param_user).to_json
  end

  post "/:user/links" do
    link = Link.create!(parsed_body)
    r_id = User.find_by(username: params["user"])

    if user_id == r_id
      Slink.create!(user_id: user_id, link_id: link.id)
    else
      Slink.create!(user_id: user_id, link_id: link.id, receiver_id: r_id)
    end
  end


  get "/:user/recommended" do
    # logic problem
    # Slink.where(receiver: params[:user]).pluck(:owner, :url).to_json
  end

  post "/:user/recommended" do
    Slink.create!(parsed_body)
  end

############

  def get_links
    Link.all.to_json
    #json user.links
  end

  delete "/:user/links/:link_id" do
    param_user = params[:user]
    if username == param_user
      data = User.find_by(username: param_user)
      del_link = params[:link_id].to_i
        if data == nil
            # username doesn't exist
            status 404
          else
            Link.find(del_link).delete
            # add slink line?
        end
    else
      status 404
    end
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
  end

  def post_new_link user
    Link.create! parsed_body
    message(user,Link.last.url)
  end

  def parsed_body
     begin
       @parsed_body ||= JSON.parse request.body.read
     rescue
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

  def user_id
    User.find_by(username: username).id
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
end
  #format is message("user","link")

if $PROGRAM_NAME == __FILE__
  LnkrrApp.run!
end
