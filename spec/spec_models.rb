class User < ActiveRecord::Base

  has_many :tasks

  def full_name
    '' << first_name.to_s << ' ' << last_name.to_s
  end

  def say_something
    "something"
  end

end


class Task < ActiveRecord::Base

  belongs_to :user

end


ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:", :database => "test")

ActiveRecord::Schema.define do

    create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "age"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "user_id"
    t.string   "heading"
    t.string   "description"
    t.integer  "time_spent"
    t.boolean  "done"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end