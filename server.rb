require 'sinatra/base'
require 'pp'

class HelloApp < Sinatra::Base
  configure do
    set :threaded, false
  end

  post '/github_hook' do
    HTTParty.post(
      "https://api2.frontapp.com/channels/cha_1e6x/incoming_messages",
      body:{
        sender: {name: 'github', handle: 'github'},
        subject: 'pull request',
        body: request.body
      })
  end
end

HelloApp.new
