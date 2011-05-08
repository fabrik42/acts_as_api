shared_examples_for "acts_as_api is enabled" do

  it "indicates that acts_as_api is enabled" do
    @user_model.acts_as_api?.should be_true
  end

  it "does respond to api_accessible" do
    @user_model.should respond_to :api_accessible
  end
end
