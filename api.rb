require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

require 'sinatra/activerecord'
require './lib/models/format_definition'

APP_ROOT = settings.root

load './lib/api/format_definition'




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
  json_errors [ { "error"  => error } ]
end

def json_errors errors
  status 500
  { "status" =>  "error", "errors" => errors }.to_json
end
