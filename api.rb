require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

require 'sinatra/activerecord'
require './lib/models/format_definition'

APP_ROOT = settings.root

get '/api/format_definition/' do
  FormatDefinition.all.to_json
end

put '/api/format_definition/new' do

  begin
    data = JSON.parse request.body.read
    klass = eval "Spatio::Reader::#{data['importer_class']}"
  rescue RuntimeError
    return json_err "Parser class Spatio::Reader::#{data['importer_class']} not found"
  rescue ParseError
    return json_err "Invalid JSON"
  end

  format_definition= FormatDefinition.new name: data["name"],
    importer_class: data["importer_class"],
    importer_parameters: data["importer_parameters"]

  if format_definition.save
    { "status" => "ok"  }.to_json
  else
    json_errors format_definition.errors
  end
end

delete '/api/format_definition/:id' do
  if FormatDefinition.delete(params[:id])
    { "status" => "ok"  }.to_json
  else
    { "status" =>  "error", "errors" => [ {"id" => "Couldn't delete"}  ] }.to_json
  end


end

def json_err error
  json_errors [ { "id"  => error } ]
end

def json_errors errors
  status 500
  { "status" =>  "error", "errors" => errors }.to_json
end
