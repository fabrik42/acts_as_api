class Untouched
  include Mongoid::Document
  
  field :nothing, :type => String
  field :created_at, :type => DateTime
  field :updated_at, :type => DateTime  
end
