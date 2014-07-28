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

ActiveRecord::Schema.define(version: 20140728203830) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.text     "description"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profilable_id",   null: false
    t.string   "profilable_type", null: false
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",           null: false
    t.string   "name",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest", null: false
  end

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "users_unit_memberships", force: true do |t|
    t.integer  "users_unit_id", null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_unit_memberships", ["user_id"], name: "index_users_unit_memberships_on_user_id", using: :btree
  add_index "users_unit_memberships", ["users_unit_id"], name: "index_users_unit_memberships_on_users_unit_id", using: :btree

  create_table "users_units", force: true do |t|
    t.integer  "group_id",   null: false
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_units", ["group_id"], name: "index_users_units_on_group_id", using: :btree

  create_table "waiting_list_memberships", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "group_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "waiting_list_memberships", ["group_id"], name: "index_waiting_list_memberships_on_group_id", using: :btree
  add_index "waiting_list_memberships", ["user_id"], name: "index_waiting_list_memberships_on_user_id", using: :btree

end
