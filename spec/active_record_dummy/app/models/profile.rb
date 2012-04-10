class Profile < ActiveRecord::Base
  attr_accessible :avatar, :homepage
  belongs_to :user    
end