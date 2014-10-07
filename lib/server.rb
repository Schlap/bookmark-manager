require 'data_mapper'
require 'sinatra'


set :views, Proc.new { File.join(root, "..", "views") }
env = ENV["RACK_ENV"] || "development"
#we're telling datamapper to use a postgreql database on local host. This will be "bookmark manager test" or "bookmarkmanager development" depending on the environment
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link' #this needs to be done after datamapper is initialised
require './lib/tag'
#After declaring your models, you should finalise them
DataMapper.finalize

#However, the database tables don't exist yet. Let's tell datamapper to create them
DataMapper.auto_upgrade!

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