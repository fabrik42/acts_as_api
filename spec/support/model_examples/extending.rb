shared_examples_for 'extending a given api template' do
  describe 'multiple times' do
    before(:each) do
      User.api_accessible :public do |t|
        t.add :first_name
      end

      User.api_accessible :for_buddies, extend: :public do |t|
        t.add :age
      end

      User.api_accessible :private, extend: :for_buddies do |t|
        t.add :last_name
      end
    end

    subject(:response) { @luke.as_api_response(:private) }

    it 'returns a hash' do
      expect(response).to be_kind_of(Hash)
    end

    it 'returns the correct number of fields' do
      expect(response).to have(3).keys
    end

    it 'returns all specified fields' do
      expect(response.keys.sort_by(&:to_s)).to eql([:age, :first_name, :last_name])
    end

    it 'returns the correct values for the specified fields' do
      expect(response.values.sort_by(&:to_s)).to eql([@luke.age, @luke.first_name, @luke.last_name].sort_by(&:to_s))
    end
  end

  describe 'and removing a former added value' do
    subject(:response) { @luke.as_api_response(:age_and_first_name) }

    it 'returns a hash' do
      expect(response).to be_kind_of(Hash)
    end

    it 'returns the correct number of fields' do
      expect(response).to have(2).keys
    end

    it 'returns all specified fields' do
      expect(response.keys.sort_by(&:to_s)).to eql([:first_name, :age].sort_by(&:to_s))
    end

    it 'returns the correct values for the specified fields' do
      expect(response.values.sort_by(&:to_s)).to eql([@luke.first_name, @luke.age].sort_by(&:to_s))
    end
  end

  describe 'and inherit a field using another template name' do
    before(:each) do
      Task.acts_as_api
      Task.api_accessible :other_template do |t|
        t.add :description
        t.add :time_spent
      end
      User.api_accessible :extending_other_template, extend: :other_sub_template
    end

    subject(:response) { @luke.as_api_response(:extending_other_template) }

    it 'returns a hash' do
      expect(response).to be_kind_of(Hash)
    end

    it 'returns the correct number of fields' do
      expect(response).to have(2).keys
    end

    it 'returns all specified fields' do
      expect(response.keys).to include(:first_name)
    end

    it 'returns the correct values for the specified fields' do
      expect(response.values).to include(@luke.first_name)
    end

    it 'returns all specified fields' do
      expect(response.keys).to include(:tasks)
    end

    it 'returns the correct values for the specified fields' do
      expect(response[:tasks]).to be_an Array
      expect(response[:tasks].size).to eq(3)
    end

    it 'contains the associated child models with the determined api template' do
      response[:tasks].each do |task|
        expect(task.keys).to include(:description, :time_spent)
        expect(task.keys.size).to eq(2)
      end
    end

    it 'contains the correct data of the child models' do
      task_hash = [@destroy_deathstar, @study_with_yoda, @win_rebellion].collect { |t| { description: t.description, time_spent: t.time_spent } }
      expect(response[:tasks]).to eql task_hash
    end
  end
end
