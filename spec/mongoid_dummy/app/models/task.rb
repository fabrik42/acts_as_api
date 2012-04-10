class Task
  include Mongoid::Document
  
  field :heading, :type => String
  field :description, :type => String
  field :time_spent, :type => Integer
  field :done, :type => Boolean
  field :created_at, :type => DateTime
  field :updated_at, :type => DateTime  
  
  embedded_in :user, :class_name => "User", :inverse_of => :task
end