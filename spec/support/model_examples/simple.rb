shared_examples_for 'listing attributes in the api template' do
  before(:each) do
    @response = @luke.as_api_response(:name_only)
  end

  it 'returns a hash' do
    expect(@response).to be_kind_of(Hash)
  end

  it 'returns the correct number of fields' do
    expect(@response).to have(2).keys
  end

  it 'returns the specified fields only' do
    expect(@response.keys).to include(:first_name, :last_name)
  end

  it 'the specified fields have the correct value' do
    expect(@response.values).to include(@luke.first_name, @luke.last_name)
  end
end
