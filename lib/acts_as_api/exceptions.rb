# frozen_string_literal: true

module ActsAsApi
  class ActsAsApiError < RuntimeError; end
  class TemplateNotFoundError < ActsAsApiError; end
end
