require 'resque'

post '/api/importer/new' do
  url = params['url']
  json_err "url field is mandatory" if url.blank?

  begin
    format_definition = FormatDefinition.find(params['format_definition'])
  rescue
    json_err "format_definition not found" if format_definition.nil?
  end

  # resque = Resque.new
  # resque << ReaderJob.new(format_definition, url)
end
