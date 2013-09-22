require 'resque'

class Api < Sinatra::Base
  get '/api/import' do
    json_api_call
    Import.all.to_json
  end

  post '/api/import/new' do
    import = Import.new params['import']

    if import.save
      import.setup_namespace
      okay
    else
      json_errors import.errors
    end
  end

  get '/api/import/:id/run' do
    import = Import.find(params[:id])
    if Resque.enqueue(Spatio::ImportJob, import.id)
      okay
    else
      json_err 'Enqueing this task did not work out'
    end
  end

  post'/api/import/:id/delete' do
    Import.delete(params[:id])
    okay
  end
end
