# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160901094107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "group_id",   null: false
    t.integer  "role",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["user_id", "group_id"], name: "index_memberships_on_user_id_and_group_id", unique: true, using: :btree

  create_table "producers", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "email",      null: false
    t.text     "address",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "producers_memberships", force: :cascade do |t|
    t.integer  "producer_id", null: false
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "role",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "producers_memberships", ["producer_id", "group_id"], name: "producers_memberships_producer_id_group_id_idx", unique: true, where: "(group_id IS NOT NULL)", using: :btree
  add_index "producers_memberships", ["producer_id", "user_id"], name: "producers_memberships_producer_id_user_id_idx", unique: true, where: "(user_id IS NOT NULL)", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",        null: false
    t.integer  "price",       null: false
    t.integer  "unit",        null: false
    t.integer  "producer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["producer_id"], name: "index_products_on_producer_id", using: :btree

  create_table "signups", force: :cascade do |t|
    t.string   "email",      null: false
    t.string   "token",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "first_name",      null: false
    t.string   "last_name",       null: false
    t.string   "username",        null: false
    t.string   "password_digest", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "producers_memberships", "groups", name: "producers_memberships_group_id_fkey"
  add_foreign_key "producers_memberships", "producers", name: "producers_memberships_producer_id_fkey"
  add_foreign_key "producers_memberships", "users", name: "producers_memberships_user_id_fkey"
end
