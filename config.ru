require "./app"
require "rack/cors"

use Rack::Cors do
  allow do
    origins "*"
    resource "*", headers: :any, methods: :any
  end
end

run TodoApp
# ...........


$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dotenv'
Dotenv.load

require 'slack-mathbot'
require 'web'

Thread.abort_on_exception = true

Thread.new do
  begin
    SlackLnkrrBot::Bot.run

  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run SlackLnkrrBot::Web
