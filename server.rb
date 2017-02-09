require 'sinatra'
require 'httparty'
require 'json'
require 'pry'

FRONTTOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzY29wZXMiOlsiKiJdLCJpc3MiOiJmcm9udCIsInN1YiI6ImFjYW55b24ifQ.ijq2oiBOyZ6-2ytyI9LIHbImQr59t_OqNiR-B_LvAAg"

def create_front_message (sender, subject, body)
  response = HTTParty.post(
    'https://api2.frontapp.com/channels/cha_1e6x/incoming_messages',
    {
      body: {
        'sender' => sender,
        'subject' => subject,
        'body' => body,
      }.to_json,
      headers: {
        'Accept' => 'application/json',
        'Authorization' => "Bearer #{FRONTTOKEN}",
        'Content-Type' => 'application/json',
        'Host' => 'api2.frontapp.com',
      }
    }
  )
  response.request
end

get '/' do 
  create_front_message({name: 'github', handle: 'github'}, 'pull request', 'test body')
end

post '/github_hook' do
  response = JSON.parse request.body.string
  sender = {handle: response['sender']['login']}
  subject = "[#{response['head']['repo']['name']}] #{response['pull_request']['title']}"
  body = "something changed"
  create_front_message({name: 'github', handle: 'github'}, subject, request.body.string)

end

