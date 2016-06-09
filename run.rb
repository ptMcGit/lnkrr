require "pry"
require "./db/setup"
require "./lib/all"
#
command = ARGV.shift
username = `git config user.name`.chomp
user = User.where(username: username).first_or_create!
puts "Welcome back, #{username}"

case command
when "lists"
  lists = user.lists
  # FIXME: n+1
  lists.each do |list|
    puts "* #{list.title} [#{list.items.count}]"
  end

when "show"
  name = ARGV.first

  # NO! This could be any users
  # list = List.find_by name: name

  # List.where(name: name, user_id: user.id).first
  # List.where(name: name, user: user).first
  list = user.lists.where(title: name).first
  unless list
    puts "Couldn't find `#{name}`"
    exit 1
  end
  list.items.each do |item|
    if item.due_date
      puts "#{item.id.to_s.rjust 4}) #{item.name} [#{item.due_date}]"
    else
      puts "#{item.id.to_s.rjust 4}) #{item.name}"
    end
  end

when "add"
  name = ARGV.shift
  list = user.lists.where(title: name).first
  item_name = ARGV.join " "
  list.add_item item_name

when "complete"
  item = Item.find_by id: ARGV.first
  if item.nil?
    puts "Can't find that item!"
    exit 1
  elsif user != item.user
    puts "That's not your item!"
    exit 1
  end
  item.mark_complete
  puts "`#{item.name}` is now complete"

else
  puts "I don't know how to `#{command}`"
end
