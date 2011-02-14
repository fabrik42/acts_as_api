class User < ActiveRecord::Base

  has_many :tasks

  def full_name
    '' << first_name.to_s << ' ' << last_name.to_s
  end

  def say_something
    "something"
  end

end