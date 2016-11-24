shared_examples_for 'trying to render an api template that is not defined' do
  it 'raises an descriptive error' do
    expect { @luke.as_api_response(:does_not_exist) }.to raise_error(ActsAsApi::TemplateNotFoundError)
  end
end
