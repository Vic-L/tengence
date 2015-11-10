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

ActiveRecord::Schema.define(version: 20151110063039) do

  create_table "current_tenders", id: false, force: :cascade do |t|
    t.string   "ref_no",               limit: 255
    t.string   "buyer_company_name",   limit: 255
    t.string   "buyer_name",           limit: 255
    t.string   "buyer_contact_number", limit: 255
    t.string   "buyer_email",          limit: 255
    t.text     "description",          limit: 65535
    t.date     "published_date"
    t.datetime "closing_datetime"
    t.string   "external_link",        limit: 2083
  end

  create_table "past_tenders", id: false, force: :cascade do |t|
    t.string   "ref_no",               limit: 255
    t.string   "buyer_company_name",   limit: 255
    t.string   "buyer_name",           limit: 255
    t.string   "buyer_contact_number", limit: 255
    t.string   "buyer_email",          limit: 255
    t.text     "description",          limit: 65535
    t.date     "published_date"
    t.datetime "closing_datetime"
    t.string   "external_link",        limit: 2083
  end

  create_table "tenders", id: false, force: :cascade do |t|
    t.string   "ref_no",               limit: 255
    t.string   "buyer_company_name",   limit: 255
    t.string   "buyer_name",           limit: 255
    t.string   "buyer_contact_number", limit: 255
    t.string   "buyer_email",          limit: 255
    t.text     "description",          limit: 65535
    t.date     "published_date"
    t.datetime "closing_datetime"
    t.string   "external_link",        limit: 2083
    t.string   "status",               limit: 255,   default: "active"
    t.string   "category",             limit: 255
    t.text     "remarks",              limit: 65535
  end

  add_index "tenders", ["ref_no"], name: "index_tenders_on_ref_no", unique: true, using: :btree

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

  create_table "watched_tenders", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "tender_id",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "watched_tenders", ["tender_id"], name: "index_watched_tenders_on_tender_id", using: :btree
  add_index "watched_tenders", ["user_id"], name: "index_watched_tenders_on_user_id", using: :btree

end
