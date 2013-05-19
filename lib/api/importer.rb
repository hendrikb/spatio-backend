require 'resque'

post '/api/importer/new' do
  url = params['url']
  json_err "url field is mandatory" if url.blank?

  namespace = params['namespace']

  json_err "namespace not found" unless FormatDefinition.valid_namespace? namespace

  # resque = Resque.new
  # resque << ReaderJob.new(format_definition, url)
end
