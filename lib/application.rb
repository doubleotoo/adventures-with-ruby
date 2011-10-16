require 'sinatra'
require 'haml'
require 'builder'
require 'yaml'
require 'cgi'

set :haml, :format => :html5, ugly: true
set :root, File.expand_path('../..', __FILE__)

# TODO stubs to make the old views work
def articles(*)
end

# TODO stubs to make the old views work
def archive
  []
end

get '/' do
  haml :index
end

get '/feed' do
  builder :rss
end

get '/articles' do
  haml :archive
end

get '/:article' do
  pass
  # haml :article
end

not_found do
  static!
  @intro = :not_found_intro
  haml :not_found
end