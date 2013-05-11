require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

set :views, Proc.new { File.join(root, "views_gui") }
set :public_folder, File.dirname(__FILE__) + '/public_gui'

set :api_url, "http://127.0.0.1:4567/api"


get '/' do
  haml :index
end

get '/format_definition' do
  #TODO This is forbidden, this must be a JSON-API call
  @format_definitions = FormatDefinition.all
  haml :format_definition_index
end
