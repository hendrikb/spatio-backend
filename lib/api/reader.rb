class Api < Sinatra::Base
  get '/api/reader' do
    json_api_call
    Spatio::AVAILABLE_READERS.map do |klass|
      klass.name.split('::').last
    end.to_json
  end
end
