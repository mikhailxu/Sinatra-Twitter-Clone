#libraries used
require "rubygems"
require "sinatra"
require "dm-core"
require "rack"
#attempt to make it so server didnt need to be manually restarted it needs work
configure :development do
  Sinatra::Application.reset!
  use Rack::Reloader
end
#database is created with sqlite3
DataMapper::setup(:default, "sqlite3://dev.db")


#this is our first model
class Chirp
  include DataMapper::Resource
  
  property :id, Serial
  property :chirp, String
  property :created_at, DateTime
  
end

Chirp.auto_migrate!
#this is the homepage
get '/' do
  multiples=[]
  5.times do
    multiples << "Odelay"
  end
  
  multiples
    
end

#this is a test
get '/hello/:name' do
  name = params[:name]
  name.gsub!(/[-_]/,' ')
  "hello #{name}"
  
end

#this is the first layout we created
get '/test' do
  haml :thing
end

#this is the posting of the chirp actually going the databasea after the form is submitted
post "/chirp" do
  chirp = Chirp.new
  chirp.attributes = {
  :chirp => params[:chirp],
  :created_at => Time.now
  }
  chirp.save
  redirect "/chirp"

end

get "/chirp" do
  

  
  chirps = Chirp.all #select * FROM 'chirp';
  #this calls the chirps haml template
  haml :chirps, :locals => {:chirps => chirps}
end
