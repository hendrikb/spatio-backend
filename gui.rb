require 'sinatra/base'

GUI_HTTP_PORT = 4568
API_URL = "http://127.0.0.1:4567/api"

#########################################

class App < Sinatra::Base
  require 'sinatra/reloader' if settings.environment == :development
  require 'sinatra/assetpack'
  set :root, File.dirname(__FILE__) # You must set app root

  set :api_url, API_URL
  set :port, GUI_HTTP_PORT

  set :views, Proc.new { File.join(root, "views_gui") }
  set :public_folder, File.dirname(__FILE__) + '/public_gui'

  register Sinatra::AssetPack

  assets {
    serve '/js',     from: 'assets_gui/js'        # Default
    serve '/vendor_js',     from: 'assets_gui/vendor/js'        # Default

    serve '/css',    from: 'assets_gui/css'       # Default
    serve '/vendor_css',     from: 'assets_gui/vendor/css'        # Default

    serve '/images', from: 'assets_gui/images'    # Default
    serve '/vendor_images',     from: 'assets_gui/vendor/images'        # Default

    # The second parameter defines where the compressed version will be served.
    # (Note: that parameter is optional, AssetPack will figure it out.)
    js :lib, '/js/lib.js', [
      '/vendor_js/*.js',
      '/vendor_js/**/*.js',
      '/vendor_js/lib/*.js',
      '/vendor_js/lib/**/*.js'
    ]

    css :lib, '/js/lib.css', [
      '/vendor_css/*.css',
      '/vendor_css/**/*.css',
      '/vendor_css/lib/*.css',
      '/vendor_css/lib/**/*.css'
    ]

    js :app, '/js/app.js', [
      '/js/*.coffee',
      '/js/*.js'
    ]

    css :app, '/css/app.css', [
      '/css/vendor/**/*.css',
      '/css/lib/**/*.css',
      '/css/*.css'
    ]

    prebuild true
    cache_dynamic_assets true

  }



  get '/' do
    haml :index, layout: :base
  end

  get '/format_definition' do
    response.headers["Access-Control-Allow-Origin"] = "*"
    haml :format_definition_index, layout: :base
  end

  get '/import' do
    response.headers["Access-Control-Allow-Origin"] = "*"
    haml :import_index, layout: :base
  end


  run! if app_file == $0
end

