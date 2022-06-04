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

ActiveRecord::Schema[7.0].define(version: 2022_05_31_122920) do
  create_table "apps", charset: "utf8mb4", force: :cascade do |t|
    t.string "token"
    t.string "name", null: false
    t.integer "chats_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_apps_on_token", unique: true
  end

  create_table "chats", charset: "utf8mb4", force: :cascade do |t|
    t.integer "number"
    t.string "app_token"
    t.integer "messages_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_token"], name: "index_chats_on_app_token"
  end

  create_table "messages", charset: "utf8mb4", force: :cascade do |t|
    t.text "text"
    t.integer "chat_number"
    t.string "app_token"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_token", "chat_number"], name: "index_messages_on_app_token_and_chat_number"
  end

end
