require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

require 'sinatra/activerecord'
require './lib/models/format_definition'

APP_ROOT = settings.root



get '/api/format_definition/' do
  FormatDefinition.all.to_json
end

put '/api/format_definition/new' do
  data = JSON.parse request.body.read
  format_definition= FormatDefinition.new name: data["name"],
                      importer_class: data["importer_class"],
                      importer_parameters: data["importer_parameters"]

  if format_definition.save
    { "status" => "ok"  }.to_json
  else
    status 500
    { "status" =>  "error", "errors" => format_definition.errors }.to_json
  end
end

delete '/api/format_definition/:id' do
  if FormatDefinition.delete(params[:id])
    { "status" => "ok"  }.to_json
  else
    { "status" =>  "error", "errors" => [ {"id" => "Couldn't delete"}  ] }.to_json
  end
end

