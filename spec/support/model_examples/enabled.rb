shared_examples_for 'acts_as_api is enabled' do
  it 'indicates that acts_as_api is enabled' do
    expect(User.acts_as_api?).to eq(true)
  end

  it 'does respond to api_accessible' do
    expect(User).to respond_to :api_accessible
  end
end
