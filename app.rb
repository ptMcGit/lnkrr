require "pry"
require "sinatra/base"
require "sinatra/json"
require "rack/cors"
require "httparty"

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
      halt_404
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
    params_user.shared_links.to_json
  end

  post "/:user/links" do
    if params_user.id == user.id
      link = create_link(parsed_body)
      Slink.create!(user_id: user.id, link_id: link.id)
      link.to_json
    else
      halt_404
    end
  end

  get "/:user/recommended" do
    params_user.rlinks.to_json
  end

  post "/:user/recommended" do
    link = create_link(parsed_body)
       Slink.create!(
      user_id: user.id,
      link_id: link.id,
      receiver_id: params_user.id
    )
    unless lnkrrbot user.username, link.url, params_user.username, link.description
      json(error: "there was a problem with lnkrrbot")
    end
   end

  delete "/:user/links/:link_id" do
    if user.username == params_user.username
      del_link = params[:link_id].to_i
      Link.find(del_link).delete
      # add slink line?
    else
      halt_404
    end
  end

  get "/:user" do
    params_user.user_profile.to_json
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
    (user = User.find_by( username: params["user"] )) || halt(404)
  end

  def lnkrrbot(user1, url, user2, description)
    unless ENV["LNKRRBOT"]
      return false
    end
    token = ENV["SLACK_PAYLOAD"] || File.read("./token.txt").chomp
    begin
      x = HTTParty.post("#{token}",
        :body => {
          :username => 'lnkrrbot',
          :channel => '#plock_recommendations',
          :text => "@#{user1} lnkrr-rd @#{user2} #{url}! #{description}"
        }.to_json,
        :headers => { 'Content-Type' => 'application/json' }
      )
    rescue => e
      return false
    end
    return true
  end

  def halt_404
    halt 404, json(error: "Not Found")
  end

  def create_link(link)
    begin
      l = Link.create! link
    rescue ActiveRecord::RecordInvalid => e
      if e.message == "Validation failed: Url has already been taken"
        return Link.find_by(url: link["url"])
      else
        halt 400
      end
    end
    l
  end
end
  #format is message("user","link")

if $PROGRAM_NAME == __FILE__
  LnkrrApp.run!
end
