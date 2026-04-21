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

ActiveRecord::Schema[8.1].define(version: 2026_04_21_041826) do
  create_table "admin_support_members", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  create_table "articles", force: :cascade do |t|
    t.integer "admin_rate"
    t.text "admin_review"
    t.float "admin_review_time"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "published_at", precision: nil
    t.text "text"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "admin_rate"
    t.boolean "approved", default: false
    t.integer "article_id"
    t.string "author"
    t.datetime "created_at", null: false
    t.integer "emotion"
    t.boolean "pinned"
    t.text "text"
    t.datetime "updated_at", null: false
  end

  create_table "loco_notifications", id: false, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.json "data"
    t.string "event"
    t.string "obj_class"
    t.bigint "obj_id"
    t.string "recipient_class"
    t.bigint "recipient_id"
    t.string "recipient_token"
    t.datetime "updated_at", null: false
    t.index ["created_at", "recipient_class", "recipient_id"], name: "index_loco_notifications_on_created_at_and_recipient"
    t.index ["created_at", "recipient_token"], name: "index_loco_notifications_on_created_at_and_recipient_token"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.bigint "room_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["room_id", "created_at"], name: "index_messages_on_room_id_and_created_at"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "confirmed_at", precision: nil
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.string "token"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["token"], name: "index_users_on_token", unique: true
  end
end
