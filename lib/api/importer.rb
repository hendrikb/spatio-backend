require 'resque'

get '/api/import' do
  require './lib/spatio'

  response_is_json
  Import.all.to_json
end

post '/api/import/new' do
  response_is_json

  begin
    import = Import.new params['import']
    if import.save!
      import.setup_namespace
      okay
    end
  rescue
    json_errors import.errors
  end
end

get '/api/import/:id/run' do
  response_is_json
  import = Import.find(params[:id])
  if Resque.enqueue(Spatio::ImportJob, import.id)
    okay
  else
    json_err "Enqueing this task did not work out"
  end
end

post'/api/import/:id/delete' do
  response_is_json
  Import.delete(params[:id])
  okay
end
