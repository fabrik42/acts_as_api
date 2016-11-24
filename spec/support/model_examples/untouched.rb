shared_examples_for 'untouched models' do
  describe 'has disabled acts_as_api by default' do
    it 'indicates that acts_as_api is disabled' do
      expect(Untouched.acts_as_api?).to eq(false)
    end

    it 'does not respond to api_accessible' do
      expect(Untouched).not_to respond_to :api_accessible
    end
  end
end
