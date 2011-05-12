require File.dirname(__FILE__) + '/../spec_helper.rb'

describe UsersController, :orm => :active_record do

  # see spec/support/controller_examples.rb
  it_behaves_like "a controller with ActsAsApi responses"

end
