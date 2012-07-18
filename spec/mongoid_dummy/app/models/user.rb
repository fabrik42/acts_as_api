class User

  include Mongoid::Document

  field :first_name, :type => String
  field :last_name, :type => String
  field :age, :type => Integer
  field :active, :type => Boolean
  field :created_at, :type => DateTime
  field :updated_at, :type => DateTime

  embeds_one :profile, :class_name => "Profile", :inverse_of => :user
  embeds_many :tasks, :class_name => "Task", :inverse_of => :user

  validates :first_name, :last_name, :presence => true

  acts_as_api

  include SharedEngine::UserTemplate

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
