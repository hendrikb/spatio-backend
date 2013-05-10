require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

require 'sinatra/activerecord'
require './lib/models/format_definition'

APP_ROOT = settings.root

get '/' do
  haml :index
end

get '/format_definition' do
  @format_definitions = FormatDefinition.all
  haml :format_definition_index
end


get '/format_definition/new' do
  haml :format_definition_new
end

