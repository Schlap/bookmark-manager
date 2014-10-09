require 'data_mapper'
require 'sinatra'
require 'rack-flash'


set :views, Proc.new { File.join(root, "..", "views") }
env = ENV["RACK_ENV"] || "development"
#we're telling datamapper to use a postgreql database on local host. This will be "bookmark manager test" or "bookmarkmanager development" depending on the environment
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link' #this needs to be done after datamapper is initialised
require './lib/tag'
require './lib/user'
#After declaring your models, you should finalise them
DataMapper.finalize

#However, the database tables don't exist yet. Let's tell datamapper to create them
DataMapper.auto_upgrade!

enable :sessions
set :session_secret, 'super secret'
use Rack::Flash

get '/' do
	@links = Link.all
	erb :index
end

post '/links' do
	url = params["url"]
	title = params["title"]
	tags = params["tags"].split(" ").map do |tag|
	#this will either find this tag or create
	#it if it doesn't exist already
	Tag.first_or_create(:text => tag)
end
	Link.create(:url => url, :title => title, :tags => tags)
	redirect to ('/')
end

get '/tags/:text' do
	tag = Tag.first(:text => params[:text])
	@links = tag ? tag.links : []
	erb :index
end

get '/users/new' do
	@user = User.new
  # note the view is in views/users/new.erb
  # we need the quotes because otherwise
  # ruby would divide the symbol :users by the
  # variable new (which makes no sense)
	erb :"users/new"
end

post '/users' do 
	@user = User.create(:email => params[:email],
				:password => params[:password],
				:password_confirmation => params[:password_confirmation])
				#the user.id will be nil if the user wasn't saved
				#becuase of password mismatch
				 # let's try saving it
  # if the model is valid,
  # it will be saved
				if @user.save
					session[:user_id] = @user.id
					redirect to ('/')
				else
					flash.now[:errors] = @user.errors.full_messages
					erb :"users/new"
		end
end

get '/sessions/new' do 
	erb :'sessions/new'
end

post '/sessions' do 
	email, password = params[:email], params[:password]
	user = User.authenticate(email, password)
	if user 
		session[:user_id] = user.id
		redirect to ('/')
	else
		flash[:errors] = ["The email or password is incorrect"]
		erb :"sessions/new"
	end

end

delete '/sessions' do
  flash[:notice] = "Good bye!"
  session[:user_id] = nil
  redirect ('/')
end

helpers do 

	def current_user
		@current_user ||= User.get(session[:user_id]) if session[:user_id]
	end
end
