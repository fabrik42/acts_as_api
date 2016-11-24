shared_examples_for 'defining a model callback' do
  describe 'for a' do
    describe 'around_api_response' do
      it 'skips rendering if not yielded' do
        @luke.skip_api_response = true
        expect(@luke.as_api_response(:name_only).keys).to include(:skipped)
      end

      it 'renders if yielded' do
        expect(@luke.as_api_response(:name_only).keys).not_to include(:skipped)
      end
    end

    describe 'before_api_response' do
      it 'is called properly' do
        @luke.as_api_response(:name_only)
        expect(@luke.before_api_response_called?).to eql(true)
      end
    end

    describe 'after_api_response' do
      it 'is called properly' do
        @luke.as_api_response(:name_only)
        expect(@luke.after_api_response_called?).to eql(true)
      end
    end
  end
end
