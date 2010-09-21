# The standard ruby Array class is extended by one method.
class Array

  # Neccessary to render an Array of models, e.g. the result of a search.
  #
  # The Array checks all its items if they respond to the +as_api_response+ method.
  # If they do, the result of this method will be collected.
  # If they don't, the item itself will be collected.
  def as_api_response(api_template)

    sub_items = []

    each do |item|
      if item.respond_to?(:as_api_response)
        sub_items << item.as_api_response(api_template)
      else
        sub_items << item
      end
    end

    sub_items

  end

end