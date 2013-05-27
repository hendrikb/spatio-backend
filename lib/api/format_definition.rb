require 'active_support/inflector'

get '/api/format_definition' do
  response_is_json
  FormatDefinition.all.to_json
end

post '/api/format_definition/new' do
  response_is_json

  require './lib/spatio'
  require './lib/spatio/reader'
  Dir.glob("./lib/spatio/reader/*.rb").each { |file| require file }

  importer_class_cleaned = params['importer_class'].match(/^[a-z0-9]+/i).to_s

  importer_parameters = JSON.parse(params["importer_parameters"]) rescue {}

  format_definition = FormatDefinition.new name: params["name"],
    importer_class: importer_class_cleaned,
    importer_parameters: importer_parameters.symbolize_keys,
    description: params["description"]

  begin
     "Spatio::Reader::#{importer_class_cleaned}".constantize
    if format_definition.save
      okay
    else
      json_errors format_definition.errors
    end
  rescue NameError
    json_err "Importer Class #{importer_class_cleaned} not found, see docs for supported classes"
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
