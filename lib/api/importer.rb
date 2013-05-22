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

  json_err "namespace not found" unless FormatDefinition.valid_namespace? namespace

  begin
    format_definition = FormatDefinition.find(params['format_definition'])
  rescue
    json_err "format_definition not found" if format_definition.nil?
  end

  Import.save name: Date.today.to_s,
    namespace: namespace,
    url: url,
    format_definition: format_definition
end

get '/api/import/:id/run' do
  import = Import.find(params[:id])
  Resque.enqueue(Spatio::ImportJob, import.id)
end
