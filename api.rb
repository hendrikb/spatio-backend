require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

require 'sinatra/activerecord'
require './lib/models/format_definition'

APP_ROOT = settings.root


post '/api/format_definition/new' do
  response_is_json

  require './lib/spatio'
  require './lib/spatio/reader'
  Dir.glob("./lib/spatio/reader/*.rb").each { |file| require file }

  begin
    data = JSON.parse request.body.read
    klass = eval "Spatio::Reader::#{data['importer_class']}"
  rescue RuntimeError
    return json_err "Parser class Spatio::Reader::#{data['importer_class']} not found"
  rescue JSON::ParserError
    return json_err "Invalid JSON"
  end

  format_definition= FormatDefinition.new name: data["name"],
    importer_class: data["importer_class"],
    importer_parameters: data["importer_parameters"]

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

delete '/api/format_definition/:id' do
  if FormatDefinition.delete(params[:id])
    okay
  else
    json_err "Could not delete"
  end
end



get '/api/format_definition/' do
  response_is_json
  FormatDefinition.all.to_json
end


def okay
  { "status" => "ok"  }.to_json
end

def json_err error
  json_errors [ { "id"  => error } ]
end

def json_errors errors
  status 500
  { "status" =>  "error", "errors" => errors }.to_json
end
