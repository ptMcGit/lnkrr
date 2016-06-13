require "pry"
require "./db/setup"
require "./lib/all"
require "./dummy_data"

def users_up
  users = []
  [
    skydaddy,
    skygranddaddy,
    storm_trooper1,
    storm_trooper2,
    storm_trooper3
  ].each do |u|
    users.push User.create! u
  end
  users
end

def links_up
  links = []
  [
    github,
    apple,
    coleman,
    wikipedia,
    spotify,
    pandora,
    yahoo,
    google,
    bing,
    myspace
  ].each do |l|
    links.push Link.create! l
  end
  links
end

def create_slink uid, lid, rid=nil
  Slink.create!(user_id: uid, link_id: lid, receiver_id: rid)
end

def data_create users, links
  users_pool = users
  users.each do |u|
    users_pool.rotate!
    links_pool = links.shuffle
    2.times do
      create_slink u.id, links_pool.pop.id, users_pool[0].id
      create_slink u.id, links_pool.pop.id
    end
  end
end

def start_it
  data_create users_up, links_up
end

binding.pry
