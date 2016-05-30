require 'sinatra'
require './keys.rb'

key_server = Keys.new(300, 60)

get '/' do
  %Q[<h3>Welcome</h3> <br> 
    /key : for generating a new key <br> 
    /access : for getting an available key <br>
    /unblock?key=abcd : unblock a key <br>
    /delete?key=abcd : delete the key <br>
    /keep_alive?key=abcd : make the key alive for next 5 minutes
  ]
end

get '/key' do
  key_server.generate
end

get '/access' do
  key = key_server.access
  if key == false
    halt 404, "NO KEYS AVAILABLE"
  else
    key
  end
end

get '/unblock' do
  key = key_server.unblock(params[:key])
  puts key
  if key == false
    "COULD NOT UNBLOCK"
  else
    "UNBLOCKED"
  end
end

get '/delete' do
  key = key_server.delete_key(params[:key])
  if key == false
    "COULD NOT DELETE"
  else
    "Done"
  end
end

get '/keep_alive' do
  key = key_server.keep_alive(params[:key])
  if keys == false
    "COULD NOT REFRESH KEY"
  else
    "REFERESHED"
  end
end