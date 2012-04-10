class Task < ActiveRecord::Base
  attr_accessible :heading, :description, :time_spent, :done
  belongs_to :user    
end