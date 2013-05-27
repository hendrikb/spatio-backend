require 'sinatra'
require 'sinatra/reloader' if settings.environment == :development

require 'sinatra/assetpack'

class App < Sinatra::Base
  register Sinatra::AssetPack

  assets {
    serve '/js',     from: 'app/js'
    serve '/css',    from: 'app/css'
    serve '/images', from: 'app/images'

    # The second parameter defines where the compressed version will be served.
    # (Note: that parameter is optional, AssetPack will figure it out.)
    js :app, '/js/app.js', [
      '/js/vendor/**/*.js',
      '/js/lib/**/*.js'
    ]

    prebuild true
    cache_dynamic_assets true
  }
end

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
