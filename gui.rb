require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

set :api_url, "http://127.0.0.1:4567/api"

set :views, Proc.new { File.join(root, "views_gui") }
set :public_folder, File.dirname(__FILE__) + '/public_gui'

get '/' do
  haml :index
end

get '/format_definition' do
  response.headers["Access-Control-Allow-Origin"] = "*"
  haml :format_definition_index
end

get '/import' do
  response.headers["Access-Control-Allow-Origin"] = "*"
  haml :import_index
end
