class User < ActiveRecord::Base

  has_many :tasks
  
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
    t.add Proc.new{ Time.now.class.to_s  }, :as => :without_param
  end  
  
  api_accessible :calling_a_lambda do |t|
    t.add lambda{|model| model.full_name.upcase  }, :as => :all_caps_name
    t.add lambda{ Time.now.class.to_s  }, :as => :without_param
  end
  
  User.api_accessible :include_tasks do |t| 
    t.add :tasks
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
    

  def full_name
    '' << first_name.to_s << ' ' << last_name.to_s
  end

  def say_something
    "something"
  end

end