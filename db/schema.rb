# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081218134828) do

  create_table "books", :force => true do |t|
    t.string   "title"
    t.string   "authors"
    t.string   "isbn"
    t.string   "image_url"
    t.string   "published_on"
    t.integer  "pages"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "image_width"
    t.integer  "image_height"
  end

  add_index "books", ["isbn"], :name => "index_books_on_isbn"

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.string   "description"
    t.datetime "created_at"
    t.integer  "book_id"
  end

  create_table "ownerships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "isbn"
  end

  add_index "ownerships", ["book_id", "user_id"], :name => "index_ownerships_on_book_id_and_user_id"
  add_index "ownerships", ["isbn", "user_id"], :name => "index_ownerships_on_isbn_and_user_id"
  add_index "ownerships", ["status", "user_id"], :name => "index_ownerships_on_status_and_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "openid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["openid"], :name => "index_users_on_openid"
  add_index "users", ["username"], :name => "index_users_on_username"

end
