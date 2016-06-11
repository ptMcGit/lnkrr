# users

def skydaddy
  {
      username: "skydaddy",
      first_name: "Luke",
      last_name: "Skywalker",
      location: "Tatooine",
      joined_date: "2016-04-05"
  }
end

def skygranddaddy
  {
      username: "skygranddaddy",
      first_name: "Darth",
      last_name: "Vader",
      location: "the Death Star",
      joined_date: "2016-04-05"
  }
end

def storm_trooper1
  {
      username: "rad_Steve",
      first_name: "Steve",
      last_name: "Miller",
      location: "the Death Star",
      joined_date: "2016-04-05"
  }
end

def storm_trooper2
  {
      username: "swellPhil",
      first_name: "Phil",
      last_name: "Winters",
      location: "the Death Star",
      joined_date: "2016-02-18"
  }
end

def storm_trooper3
  {
      username: "MojoMike",
      first_name: "Mike",
      last_name: "Storm",
      location: "The Death Star",
      joined_date: "2015-12-28"
  }
end

# Links

def github
  {
      title: "GitHub",
      url: "http://www.github.com",
      description: "Site for sharing software",
      timestamp: "2016-06-01 05:45:01"
  }
end

def apple
  {
      title: "Apple Computers",
      url: "http://www.apple.com",
      description: "Apple computer company website",
      timestamp: "2016-02-05 03:45:01"
  }
end

def wikipedia
  {
    title: "Wikipedia",
    url: "http://www.wikipedia.org",
    description: "Free information",
    timestamp: "2016-02-05 12:50:22"
  }
end

def skydaddy_apple_granddaddy
  {
    owner: User.find_by(username: "skydaddy").id.to_s,
    url: Link.find_by(title: "Apple Computers").id.to_s,
    receiver: User.find_by(username: "skygranddaddy").id.to_s
  }
end
