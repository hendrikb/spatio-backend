require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

APP_ROOT = settings.root

get '/' do
  haml :index
end

end
