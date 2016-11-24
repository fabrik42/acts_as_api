require 'spec_helper'

describe SharedEngine::UsersController, type: :controller do
  before(:each) do
    setup_models
  end

  after(:each) do
    clean_up_models
  end

  # see spec/support/controller_examples.rb
  it_behaves_like 'a controller with ActsAsApi responses'
end
