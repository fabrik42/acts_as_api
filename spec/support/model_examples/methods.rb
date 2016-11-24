shared_examples_for 'calling a method in the api template' do
  before(:each) do
    @response = @luke.as_api_response(:only_full_name)
  end

  it 'returns a hash' do
    expect(@response).to be_kind_of(Hash)
  end

  it 'returns the correct number of fields' do
    expect(@response).to have(1).keys
  end

  it 'returns all specified fields by name' do
    expect(@response.keys).to include(:full_name)
  end

  it 'returns the correct values for the specified fields' do
    expect(@response.values).to include(@luke.full_name)
  end
end
