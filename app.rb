require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

require 'sinatra/activerecord'
require './lib/models/format_definition'

APP_ROOT = settings.root

get '/' do
  haml :index
end

get '/format_definition' do
  @format_definitions = FormatDefinition.all
  haml :format_definition_index
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

