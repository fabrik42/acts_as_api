shared_examples_for 'calling a closure in the api template' do
  describe 'i.e. a proc (the record is passed as only parameter)' do
    subject(:response) { @luke.as_api_response(:calling_a_proc) }

    it 'returns a hash' do
      expect(response).to be_kind_of(Hash)
    end

    it 'returns the correct number of fields' do
      expect(response).to have(2).keys
    end

    it 'returns all specified fields' do
      expect(response.keys.sort_by(&:to_s)).to eql([:all_caps_name, :without_param])
    end

    it 'returns the correct values for the specified fields' do
      expect(response.values.sort).to eql(['LUKE SKYWALKER', 'Time'])
    end
  end

  describe 'i.e. a lambda (the record is passed as only parameter)' do
    subject(:response) { @luke.as_api_response(:calling_a_lambda) }

    it 'returns a hash' do
      expect(response).to be_kind_of(Hash)
    end

    it 'returns the correct number of fields' do
      expect(response).to have(2).keys
    end

    it 'returns all specified fields' do
      expect(response.keys.sort_by(&:to_s)).to eql([:all_caps_name, :without_param])
    end

    it 'returns the correct values for the specified fields' do
      expect(response.values.sort).to eql(['LUKE SKYWALKER', 'Time'])
    end
  end
end
