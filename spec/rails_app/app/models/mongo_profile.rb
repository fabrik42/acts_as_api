class MongoProfile
  include Mongoid::Document

  field :avatar, :type => String
  field :homepage, :type => String
  field :created_at, :type => DateTime
  field :updated_at, :type => DateTime

  embedded_in :user, :class_name => "MongoUser", :inverse_of => :profile
end