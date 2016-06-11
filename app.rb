
require "pry"
require "sinatra/base"
require "sinatra/json"
require "rack/cors"

require "./db/setup"
require "./lib/all"

class LnkrrApp < Sinatra::Base
  set :logging, true
  set :show_exceptions, false

  use Rack::Cors do
    allow do
      origins "*"
      resource "*", headers: :any, methods: :any
    end
  end

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

  get "/:user/links" do
    u = User.find_by(username: params_user)
    u.links.to_json
  end

  post "/:user/links" do
    link = Link.create!(parsed_body)
    sender = User.find_by(username: params_user)
    if sender
      if sender.id == user.id
        Slink.create!(user_id: user.id, link_id: link.id)
      else
        # you are trying to post to someone else's links
      end
    end
  end

  get "/:user/recommended" do
    u = User.find_by(username: params_user)
    u.rlinks.to_json
  end

  post "/:user/recommended" do
    link = Link.create!(parsed_body)
    receiver = User.find_by(username: params_user)
    Slink.create!(
      user_id: user.id,
      link_id: link.id,
      receiver_id: receiver.id
    )
  end

  delete "/:user/links/:link_id" do
    if user.username == params_user
      data = User.find_by(username: params_user)
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
#    data = User.where(username: params_user)
#    if data == nil
#      # username doesn't exist
#    else
#      data.to_json
#    end
    #  end
    json User.find_by(username: params_user)
  end


  def parsed_body
     begin
       @parsed_body ||= JSON.parse request.body.read
     rescue JSON::ParserError
       halt 400
     end
  end

  def require_authorization!
    unless user.username
      halt(
        401,
        json("status": "error", "error": "You must log in.")
      )
    end
  end

  def user
    auth = request.env["HTTP_AUTHORIZATION"].split(":")
    username = auth[0]
    pass = auth[1]

    halt 401 unless username && pass
    (user = User.find_by( username: username )) || halt(403)
    user
  end

  def params_user
    params["user"]
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
