require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

require 'sinatra/activerecord'
require './lib/models/format_definition'

APP_ROOT = settings.root


#########

get '/api/ping' do
  response_is_json
  true.to_json
end

require_relative 'lib/api/format_definition'
require_relative 'lib/api/importer'

def response_is_json
  response.headers["Access-Control-Allow-Origin"] = "*"
  # response.headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, DELETE, PUT'
  # response.headers['Access-Control-Max-Age'] = '1000'
  # response.headers['Access-Control-Allow-Headers'] = 'origin, x-csrftoken, content-type, accept'
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
