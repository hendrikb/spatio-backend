class Api < Sinatra::Base
  private
  def json_api_call
    response_is_json
    cross_domain_call_allowed
  end

  def response_is_json
    content_type :json
  end

  def okay
    cross_domain_call_allowed
    status 200
  end

  def json_err error
    json_errors [ error  ]
  end

  def json_errors errors
    cross_domain_call_allowed
    status 500
    response_is_json
    { "status" =>  "error", "errors" =>  errors.to_a }.to_json
  end


  def cross_domain_call_allowed
    response.headers["Access-Control-Allow-Origin"] = "*"
  end
end
