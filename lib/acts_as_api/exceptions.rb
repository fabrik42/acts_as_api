module ActsAsApi
  class ActsAsApiError < RuntimeError; end
  class TemplateNotFoundError < ActsAsApiError; end  
end