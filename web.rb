require 'sinatra/base'

module SlackLnkrrBot
  class Web < Sinatra::Base
    get '/' do
      'Stay Awake'
    end
  end
end
