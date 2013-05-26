require 'resque'

get '/api/import' do
  require './lib/spatio'

  response_is_json
  Import.all.to_json
end

post '/api/import/new' do
  url = params['url']
  json_err "url field is mandatory" if url.blank?

  namespace = params['namespace']


  begin
    format_definition = FormatDefinition.find(params['format_definition'])
  rescue
    json_err "format_definition not found" if format_definition.nil?
  end

  import = Import.new name: Date.today.to_s,
    namespace: namespace,
    url: url,
    format_definition: format_definition

  begin
    if format_definition.save
      import.create_namespace
      okay
    else
      json_errors format_definition.errors
    end
  rescue
    json_err "Error while creating Import"
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
