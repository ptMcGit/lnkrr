require "pry"
require "sinatra/base"
require "sinatra/json"

require "./db/setup"
require "./lib/all"

class LnkrrApp < Sinatra::Base
  set :logging, true
  set :show_exceptions, false

  error do |e|
    if e.is_a? ActiveRecord::RecordNotFound
      halt 404, json(error: "Not Found")
    elsif e.is_a? ActiveRecord::RecordInvalid
      halt 422, json(error: e.message)
    else
      puts e.message
    end
  end

  before do
    require_authorization!
  end

#################

  get "/:user/links" do
    u = User.find_by(username: params["user"])
    u.links
  end

  post "/:user/links" do
    link = Link.create!(parsed_body)
    sender = User.find_by(username: params["user"])
    if sender
      if sender.id == user_id
        Slink.create!(user_id: user_id, link_id: link.id)
      else
        # you are trying to post to someone else's links
      end
    end
  end

  get "/:user/recommended" do
    binding.pry
    # logic problem
    # Slink.where(receiver: params[:user]).pluck(:owner, :url).to_json
  end

  post "/:user/recommended" do
    link = Link.create!(parsed_body)
    receiver = User.find_by(username: params["user"])
    Slink.create!(
      user_id: user_id,
      link_id: link.id,
      receiver_id: receiver.id
    )
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
     rescue JSON::ParserError
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
    username = request.env["HTTP_AUTHORIZATION"]
    halt 401 unless username
    (u = User.find_by( username: username )) || halt(403)
    u.username
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
