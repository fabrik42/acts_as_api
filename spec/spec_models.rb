class Customer < ActiveRecord::Base

  has_many :orders

  #acts_as_api

  # define the accessible attributes/methods for the api response
  #api_accessible :firstname, :age, :created_at, :lastname, :full_name,
    # include associated model in response
  #  :orders,
    # rename the key for orders
  #  :renamed_orders => :orders,
    # put orders in another subnode
  #  :subnode_orders =>  { :sub_oders => :orders },
    # rename nodes/tag names
 #   :other_node => :say_something,
    # create a deeper node hierarchy
  #  :maybe => { :useful => { :for => :say_something } }

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

  api_accessible :city, :amount

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