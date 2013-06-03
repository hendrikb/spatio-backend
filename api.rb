require 'sinatra/base'

API_HTTP_PORT = 4567

class Api < Sinatra::Base
  require './lib/spatio'
  require 'sinatra/reloader' if settings.environment == :development

  set :root, File.dirname(__FILE__) # You must set app root
  APP_ROOT = settings.root
  set :port, API_HTTP_PORT


  #########

  require './lib/api/format_definition'
  require './lib/api/importer'
  require './lib/helpers/response_helpers'


  get '/api/ping' do
    okay
  end


  run! if app_file == $0
end
