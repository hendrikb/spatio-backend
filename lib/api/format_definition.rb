require 'active_support/inflector'

def parse_params params
  importer_parameters = JSON.parse(params["importer_parameters"]) rescue {}
  {
    name: params['name'],
    importer_class: params['importer_class'].match(/^[a-z0-9]+/i).to_s,
    importer_parameters: importer_parameters.symbolize_keys,
    description: params["description"]
  }
end

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
    format_definition = FormatDefinition.new(parse_params(params))
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
  FormatDefinition.delete(params[:id])
  okay
end
