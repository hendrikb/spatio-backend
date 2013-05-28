require 'resque'

get '/api/import' do
  require './lib/spatio'

  response_is_json
  Import.all.to_json
end

post '/api/import/new' do
  response_is_json

  begin
    format = FormatDefinition.find(params['format_definition'])
  rescue
    json_err 'Invalid FormatDefinition'
  end

  import = Import.new name: params['name'],
    namespace: params['namespace'],
    geo_context: params['geo_context'],
    url: params['url'],
    format_definition: format,
    description: params['description']

  begin
    if import.save!
      # TODO: validation that FormatDefinitions are compatible if namespace already
      # exists
      import.create_namespace
      okay
    end
  rescue
    json_errors import.errors
  end
end

get '/api/import/:id/run' do
  response_is_json
  import = Import.find(params[:id])
  if Resque.enqueue(Spatio::ImportJob, import.id)
    okay
  else
    json_err "Enqueing this task did not work out"
  end
end

post'/api/import/:id/delete' do
  response_is_json
  Import.delete(params[:id])
  okay
end
