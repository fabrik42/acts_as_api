class Customer < ActiveRecord::Base

  has_many :orders

  def full_name
    '' << firstname.to_s << ' ' << lastname.to_s
  end

  def say_something
    "something"
  end

end


class Order < ActiveRecord::Base

  belongs_to :customer

  acts_as_api

  api_accessible :v1_default => [ :city, :amount ]

end


ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:", :database => "test")

ActiveRecord::Schema.define do

    create_table "customers", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "age"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "amount"
    t.string   "city"
    t.string   "postcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end