#i'm adding shit so that i can commit it

#libraries used
require "rubygems"
require "sinatra"
require "dm-core"
require "rack"
require "redis"

r = Redis.new
n = (ARGV.shift || 20000).to_i

#attempt to make it so server didnt need to be manually restarted it needs work
configure :development do
  Sinatra::Application.reset!
  use Rack::Reloader
end
#database is created with sqlite3
DataMapper::setup(:default, "sqlite3://#{File.dirname(__FILE__)}/dev.db")


#this is our first model
class Chirp
  include DataMapper::Resource
  
  property :id, Serial
  property :chirp, String
  property :created_at, DateTime
  
end
#File is caps cuz it is a class
# #{this little deal is ruby code that formats a string}
unless File.exists? "#{File.dirname(__FILE__)}/dev.db"  #this line will protect our old chirps from being wiped out when server restarts ? is a boolean convention in ruby
  Chirp.auto_migrate!  #this line will blow away the database and recreate a new one with DataMapper
end

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
#this is the way that you correctly make stuff save into the database we got rid of the attributes thing
post "/chirp" do
  chirp = Chirp.new(
  :chirp => params[:chirp],
  :created_at => Time.now
  )
  chirp.save
  redirect "/chirp"

end

get "/chirp" do
  

  
  chirps = Chirp.all #select * FROM 'chirp';
  #this calls the chirps haml template
  haml :chirps, :locals => {:chirps => chirps}
end
