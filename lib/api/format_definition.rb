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
  begin
    if (importer_class_cleaned.blank? or params['importer_class'].blank?)
      raise '"name" and "importer_class" are mandatory fields'
    end
    klass = "Spatio::Reader::#{importer_class_cleaned}".constantize
  rescue NameError
    return json_err "Parser class Spatio::Reader::#{importer_class_cleaned} not found"
  rescue => detail
    return json_err "Error: #{detail.to_s}"
  end

  format_definition= FormatDefinition.new name: params["name"],
    importer_class: importer_class_cleaned,
    importer_parameters: params["importer_parameters"],
    description: params["description"]

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
