# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_10_20_200519) do
  create_table "admin_support_members", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at", precision: nil
    t.integer "user_id"
    t.integer "admin_rate"
    t.text "admin_review"
    t.integer "category_id"
    t.float "admin_review_time"
  end

  create_table "comments", force: :cascade do |t|
    t.string "author"
    t.text "text"
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "emotion"
    t.boolean "pinned"
    t.integer "admin_rate"
    t.boolean "approved", default: false
  end

  create_table "connections", force: :cascade do |t|
    t.string "obj_class"
    t.integer "obj_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loco_notifications", id: false, force: :cascade do |t|
    t.string "obj_class"
    t.bigint "obj_id"
    t.string "event"
    t.text "data"
    t.string "recipient_class"
    t.bigint "recipient_id"
    t.string "recipient_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at", "recipient_class", "recipient_id"], name: "index_loco_notifications_on_created_at_and_recipient"
    t.index ["created_at", "recipient_token"], name: "index_loco_notifications_on_created_at_and_recipient_token"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at", precision: nil
  end
end
