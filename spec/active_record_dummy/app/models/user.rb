class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :age, :active
  validates :first_name, :last_name, :presence => true

  has_many :tasks

  has_one :profile

  acts_as_api

  api_accessible :name_only do |t|
    t.add :first_name
    t.add :last_name
  end

  api_accessible :only_full_name do |t|
    t.add :full_name
  end

  api_accessible :rename_last_name do |t|
    t.add :last_name, :as => :family_name
  end

  api_accessible :rename_full_name do |t|
    t.add :full_name, :as => :other_full_name
  end

  api_accessible :with_former_value do |t|
    t.add :first_name
    t.add :last_name
  end

  api_accessible :age_and_first_name, :extend => :with_former_value do |t|
    t.add :age
    t.remove :last_name
  end

  api_accessible :calling_a_proc do |t|
    t.add Proc.new{|model| model.full_name.upcase  }, :as => :all_caps_name
    t.add Proc.new{|model| Time.now.class.to_s  }, :as => :without_param
  end

  api_accessible :calling_a_lambda do |t|
    t.add lambda{|model| model.full_name.upcase  }, :as => :all_caps_name
    t.add lambda{|model| Time.now.class.to_s  }, :as => :without_param
  end
  api_accessible :include_tasks do |t|
    t.add :tasks
  end

  api_accessible :include_profile do |t|
    t.add :profile
  end

  api_accessible :other_sub_template do |t|
    t.add :first_name
    t.add :tasks, :template => :other_template
  end

  api_accessible :include_completed_tasks do |t|
    t.add "tasks.completed.all", :as => :completed_tasks
  end

  api_accessible :sub_node do |t|
    t.add Hash[:foo => :say_something], :as => :sub_nodes
  end

  api_accessible :nested_sub_node do |t|
    t.add Hash[:foo, Hash[:bar, :last_name]], :as => :sub_nodes
  end

  api_accessible :nested_sub_hash do |t|
    t.add :sub_hash
  end

  api_accessible :if_over_thirty do |t|
    t.add :first_name
    t.add :last_name, :if => :over_thirty?
  end

  api_accessible :if_returns_nil do |t|
    t.add :first_name
    t.add :last_name, :if => :return_nil
  end

  api_accessible :if_over_thirty_proc do |t|
    t.add :first_name
    t.add :last_name, :if => lambda{|u| u.over_thirty? }
  end

  api_accessible :if_returns_nil_proc do |t|
    t.add :first_name
    t.add :last_name, :if => lambda{|u| nil }
  end

  api_accessible :unless_under_thirty do |t|
    t.add :first_name
    t.add :last_name, :unless => :under_thirty?
  end

  api_accessible :unless_returns_nil do |t|
    t.add :first_name
    t.add :last_name, :unless => :return_nil
  end

  api_accessible :unless_under_thirty_proc do |t|
    t.add :first_name
    t.add :last_name, :unless => lambda{|u| u.under_thirty? }
  end

  api_accessible :unless_returns_nil_proc do |t|
    t.add :first_name
    t.add :last_name, :unless => lambda{|u| nil }
  end

  api_accessible :with_prefix_name_only do |t|
    t.add lambda{|model| 'true' }, :as => :prefix
    t.add :first_name
    t.add :last_name
  end

  api_accessible :name_only_with_postfix do |t|
    t.add :first_name
    t.add :last_name
    t.add lambda{|model| 'true' }, :as => :postfix
  end

  api_accessible :with_prefix_name_only_with_postfix do |t|
    t.add lambda{|model| 'true' }, :as => :prefix
    t.add :first_name
    t.add :last_name
    t.add lambda{|model| 'true' }, :as => :postfix
  end
  
  def before_api_response(api_response)
    @before_api_response_called = true
  end
  
  def before_api_response_called?
    !!@before_api_response_called
  end
  
  def after_api_response(api_response)
    @after_api_response_called = true
  end
  
  def after_api_response_called?
    !!@after_api_response_called
  end
  
  def skip_api_response=(should_skip)
    @skip_api_response = should_skip
  end
  
  def around_api_response(api_response)
    @skip_api_response ? { :skipped => true } : yield
  end

  def over_thirty?
    age > 30
  end

  def under_thirty?
    age < 30
  end

  def return_nil
    nil
  end

  def full_name
    '' << first_name.to_s << ' ' << last_name.to_s
  end

  def say_something
    "something"
  end

  def sub_hash
    {
      :foo => "bar",
      :hello => "world"
    }
  end

end
