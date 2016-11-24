module ActsAsApi
  module Collection
    # The collection checks all its items if they respond to the +as_api_response+ method.
    # If they do, the result of this method will be collected.
    # If they don't, the item itself will be collected.
    def as_api_response(api_template, options = {})
      collect do |item|
        if item.respond_to?(:as_api_response)
          item.as_api_response(api_template, options)
        else
          item
        end
      end
    end
  end
end
