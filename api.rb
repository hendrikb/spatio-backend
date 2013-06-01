require 'sinatra/base'

API_HTTP_PORT = 4567

class Api < Sinatra::Base
  require 'sinatra/activerecord'
  require './app/models'
  require 'sinatra/reloader' if settings.environment == :development

  set :root, File.dirname(__FILE__) # You must set app root
  APP_ROOT = settings.root
  set :port, API_HTTP_PORT


  #########

  get '/api/ping' do
    response.headers["Access-Control-Allow-Origin"] = "*"
    status 200
  end

  require_relative 'lib/api/format_definition'
  require_relative 'lib/api/importer'

  def response_is_json
    require 'pry'; binding.pry
    response.headers["Access-Control-Allow-Origin"] = "*"
    content_type :json
  end

  def okay
    { "status" => "ok"  }.to_json
  end

  def json_err error
    json_errors [ error  ]
  end

  def json_errors errors
    status 500
    { "status" =>  "error", "errors" =>  errors.to_a }.to_json
  end
  run! if app_file == $0
end
