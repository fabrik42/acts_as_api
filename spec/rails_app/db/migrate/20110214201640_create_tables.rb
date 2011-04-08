class CreateTables < ActiveRecord::Migration
  def self.up

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
    
    create_table "profiles", :force => true do |t|
      t.integer  "user_id"
      t.string   "avatar"
      t.string   "homepage"
      t.datetime "created_at"
      t.datetime "updated_at"
    end    
    
    create_table :untoucheds do |t|
      t.string   "nothing"
      t.timestamps
    end

  end

  def self.down
    drop_table :untoucheds
    drop_table :profiles
    drop_table :tasks
    drop_table :users    
  end
end
