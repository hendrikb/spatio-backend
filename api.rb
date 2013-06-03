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


  get '/api/ping' do
    okay
  end

  def json_api_call
    response_is_json
    cross_domain_call_allowed
  end

  def response_is_json
    content_type :json
  end

  def okay
    cross_domain_call_allowed
    status 200
  end

  def json_err error
    json_errors [ error  ]
  end

  def json_errors errors
    allow_crossdomain_calls
    status 500
    response_is_json
    { "status" =>  "error", "errors" =>  errors.to_a }.to_json
  end


  def cross_domain_call_allowed
    response.headers["Access-Control-Allow-Origin"] = "*"
  end

  run! if app_file == $0
end
