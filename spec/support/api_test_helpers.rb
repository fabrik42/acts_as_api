module ApiTestHelpers
  
  def response_body
    response.body.strip
  end
  
  def response_body_json
    ActiveSupport::JSON.decode(response_body)
  end
  
  def response_body_jsonp(callback)
    jsonp_callback(callback).match(response_body)
  end
  
  def jsonp_callback(callback)
    /\A#{callback}\((.*),\s+\d{3}\)\z/
  end
  
end

RSpec.configure do |c|
  c.include ApiTestHelpers
end