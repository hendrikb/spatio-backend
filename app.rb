require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

APP_ROOT = settings.root

get '/' do
    "Hello World!"
end
