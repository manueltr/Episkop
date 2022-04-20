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

ActiveRecord::Schema.define(version: 2022_04_16_165823) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "in_req_mode"
    t.boolean "accepted"
    t.text "explanation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "api_token"
    t.boolean "create_key"
    t.boolean "delete_key"
    t.boolean "extract_key"
    t.boolean "edit_key"
    t.index ["api_token"], name: "index_api_keys_on_api_token", unique: true
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "directories", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.index ["parent_id"], name: "index_directories_on_parent_id"
    t.index ["user_id"], name: "index_directories_on_user_id"
  end

  create_table "poll_answers", force: :cascade do |t|
    t.bigint "poll_id"
    t.bigint "poll_question_id"
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["poll_id"], name: "index_poll_answers_on_poll_id"
    t.index ["poll_question_id"], name: "index_poll_answers_on_poll_question_id"
  end

  create_table "poll_graphs", force: :cascade do |t|
    t.bigint "poll_id"
    t.string "graph_type"
    t.string "questions"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["poll_id"], name: "index_poll_graphs_on_poll_id"
  end

  create_table "poll_questions", force: :cascade do |t|
    t.bigint "poll_id"
    t.string "question_type"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["poll_id"], name: "index_poll_questions_on_poll_id"
  end

  create_table "poll_votes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "poll_id"
    t.bigint "poll_question_id"
    t.bigint "poll_answer_id"
    t.boolean "submitted"
    t.text "response"
    t.index ["poll_answer_id"], name: "index_poll_votes_on_poll_answer_id"
    t.index ["poll_id"], name: "index_poll_votes_on_poll_id"
    t.index ["poll_question_id"], name: "index_poll_votes_on_poll_question_id"
    t.index ["user_id"], name: "index_poll_votes_on_user_id"
  end

  create_table "polls", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.text "summary"
    t.boolean "opened"
    t.datetime "ends_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "publish"
    t.string "invite_token"
    t.bigint "directory_id"
    t.index ["directory_id"], name: "index_polls_on_directory_id"
    t.index ["invite_token"], name: "index_polls_on_invite_token", unique: true
    t.index ["user_id"], name: "index_polls_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "firstname"
    t.string "uid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "photo"
    t.boolean "admin"
  end

  add_foreign_key "api_keys", "users"
  add_foreign_key "poll_questions", "polls"
  add_foreign_key "poll_votes", "poll_answers"
  add_foreign_key "poll_votes", "poll_questions"
  add_foreign_key "poll_votes", "polls"
  add_foreign_key "poll_votes", "users"
end
