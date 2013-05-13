require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

require 'sinatra/activerecord'
require './lib/models/format_definition'

APP_ROOT = settings.root


get '/api/format_definition' do
  response_is_json
  FormatDefinition.all.to_json
end

post '/api/format_definition/new' do
  response_is_json

  require './lib/spatio'
  require './lib/spatio/reader'
  Dir.glob("./lib/spatio/reader/*.rb").each { |file| require file }

  begin
    klass = eval "Spatio::Reader::#{params['importer_class']}"
  rescue RuntimeError
    return json_err "Parser class Spatio::Reader::#{params['importer_class']} not found"
  end

  format_definition= FormatDefinition.new name: params["name"],
    importer_class: params["importer_class"],
    importer_parameters: params["importer_parameters"]

  begin
    if format_definition.save
      okay
    else
      json_errors format_definition.errors
    end
  rescue ActiveRecord::RecordNotUnique
    json_err "Record name must be unique"
  end
end

post'/api/format_definition/:id/delete' do
  response_is_json
  if FormatDefinition.delete(params[:id])
    okay
  else
    json_err "Could not delete"
  end
end






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
