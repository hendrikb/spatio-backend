require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

get '/' do
  haml :index
end

get '/v/format_definition' do
  #TODO This is forbidden, this must be a JSON-API call
  @format_definitions = FormatDefinition.all
  haml :format_definition_index
end
