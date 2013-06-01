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
  json_api_call
  FormatDefinition.all.to_json
end

post '/api/format_definition/new' do

  format_definition = FormatDefinition.new(parse_params(params))
  if format_definition.save
    okay
  else
    json_errors format_definition.errors
  end
end

post'/api/format_definition/:id/delete' do
  FormatDefinition.delete(params[:id])
end
