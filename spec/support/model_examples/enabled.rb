shared_examples_for "acts_as_api is enabled" do

  it "indicates that acts_as_api is enabled" do
    User.acts_as_api?.should be_true
  end

  it "does respond to api_accessible" do
    User.should respond_to :api_accessible
  end
end
