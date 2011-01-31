# encoding: UTF-8
require 'cgi'

module AdventuresWithRuby
  class Application < Sinatra::Base

    set :public, File.expand_path('../../../public', __FILE__)

    set :haml, :format => :html5, ugly: true

    before do
      # no www
      redirect "#{request.scheme}://#{$1}", 301 if request.url =~ %r|^#{request.scheme}://www\.(.*)$|
      # no /1945/5/the-war-has-ended posts
      redirect "#{request.scheme}://#{request.host}/#{$1}", 301 if request.url =~ %r|/20\d\d/\d{1,2}/(.*)$|
    end

    get '/' do
      @archive = Archive.new
      response['Cache-Control'] = 'public, max-age=3600'
      etag @archive.first.etag
      haml :index
    end

    get '/rss.xml' do
      @archive = Archive.new
      builder :rss
    end

    get '/archive' do
      @archive = Archive.new
      haml :archive
    end

    get '/:article' do
      @article = Archive.find(params[:article])
      pass unless @article.found?
      response['Cache-Control'] = 'public, max-age=3600'
      etag @article.etag
      haml :article
    end

    not_found do
      haml :not_found
    end

  end
end
