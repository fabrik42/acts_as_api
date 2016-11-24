shared_examples_for 'creating a sub hash in the api template' do
  describe 'and putting an attribute in it' do
    before(:each) do
      @response = @luke.as_api_response(:sub_node)
    end

    it 'returns a hash' do
      expect(@response).to be_kind_of(Hash)
    end

    it 'returns the correct number of fields' do
      expect(@response).to have(1).keys
    end

    it 'returns all specified fields' do
      expect(@response.keys).to include(:sub_nodes)
    end

    it 'returns the correct values for the specified fields' do
      expect(@response[:sub_nodes]).to be_a Hash
    end

    it 'provides the correct number of sub nodes' do
      expect(@response[:sub_nodes]).to have(1).keys
    end

    it 'provides the correct sub nodes values' do
      expect(@response[:sub_nodes][:foo]).to eql('something')
    end
  end

  describe 'multiple times and putting an attribute in it' do
    before(:each) do
      @response = @luke.as_api_response(:nested_sub_node)
    end

    it 'returns a hash' do
      expect(@response).to be_kind_of(Hash)
    end

    it 'returns the correct number of fields' do
      expect(@response).to have(1).keys
    end

    it 'returns all specified fields' do
      expect(@response.keys).to include(:sub_nodes)
    end

    it 'returns the correct values for the specified fields' do
      expect(@response[:sub_nodes]).to be_a Hash
    end

    it 'provides the correct number of sub nodes' do
      expect(@response[:sub_nodes]).to have(1).keys
    end

    it 'provides the correct number of sub nodes in the second level' do
      expect(@response[:sub_nodes][:foo]).to have(1).keys
    end

    it 'provides the correct sub nodes values' do
      @response[:sub_nodes][:foo].tap do |foo|
        foo[:bar].tap do |bar|
          expect(bar).to eql(@luke.last_name)
        end
      end
    end
  end

  describe 'using a method' do
    before(:each) do
      @response = @luke.as_api_response(:nested_sub_hash)
    end

    it 'returns a hash' do
      expect(@response).to be_kind_of(Hash)
    end

    it 'returns the correct number of fields' do
      expect(@response).to have(1).keys
    end

    it 'returns all specified fields' do
      expect(@response.keys).to include(:sub_hash)
    end

    it 'provides the correct number of sub nodes' do
      expect(@response[:sub_hash]).to have(2).keys
    end

    it 'provides the correct sub nodes' do
      expect(@response[:sub_hash].keys).to include(:foo, :hello)
    end

    it 'provides the correct values in its sub nodes' do
      expect(@response[:sub_hash].values).to include('bar', 'world')
    end
  end
end
