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

ActiveRecord::Schema.define(version: 20151025173536) do

  create_table "current_tenders", id: false, force: :cascade do |t|
    t.string   "ref_no",               limit: 255
    t.string   "primary_key",          limit: 255
    t.string   "buyer_company_name",   limit: 255
    t.string   "buyer_name",           limit: 255
    t.string   "buyer_contact_number", limit: 255
    t.string   "buyer_email",          limit: 255
    t.text     "description",          limit: 65535
    t.date     "published_date"
    t.datetime "closing_datetime"
  end

  create_table "past_tenders", id: false, force: :cascade do |t|
    t.string   "ref_no",               limit: 255
    t.string   "primary_key",          limit: 255
    t.string   "buyer_company_name",   limit: 255
    t.string   "buyer_name",           limit: 255
    t.string   "buyer_contact_number", limit: 255
    t.string   "buyer_email",          limit: 255
    t.text     "description",          limit: 65535
    t.date     "published_date"
    t.datetime "closing_datetime"
  end

  create_table "tenders", id: false, force: :cascade do |t|
    t.string   "ref_no",               limit: 255
    t.string   "primary_key",          limit: 255
    t.string   "buyer_company_name",   limit: 255
    t.string   "buyer_name",           limit: 255
    t.string   "buyer_contact_number", limit: 255
    t.string   "buyer_email",          limit: 255
    t.text     "description",          limit: 65535
    t.date     "published_date"
    t.datetime "closing_datetime"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "",     null: false
    t.string   "encrypted_password",     limit: 255,   default: "",     null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "users",                  limit: 255,   default: "free"
    t.string   "braintree_customer_id",  limit: 255
    t.string   "string",                 limit: 255,   default: "free"
    t.string   "first_name",             limit: 255,   default: "",     null: false
    t.string   "last_name",              limit: 255,   default: "",     null: false
    t.string   "company_name",           limit: 255,   default: "",     null: false
    t.text     "keywords",               limit: 65535
    t.text     "text",                   limit: 65535
    t.string   "subscribed_plan",        limit: 255,   default: "free"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
