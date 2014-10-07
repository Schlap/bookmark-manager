require 'sinatra/base'

class BookMarkManager < Sinatra::Base
  get '/' do
    'Hello BookMarkManager!'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
