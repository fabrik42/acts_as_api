shared_examples_for "trying to render an api template that is not defined" do

  it "raises an descriptive error" do
    lambda{ @luke.as_api_response(:does_not_exist) }.should raise_error(ActsAsApi::TemplateNotFoundError)
  end

end