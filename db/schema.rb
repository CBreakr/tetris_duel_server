# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_04_042016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_states", force: :cascade do |t|
    t.integer "game_id"
    t.string "board_state"
    t.string "next_piece"
    t.integer "move_number"
    t.boolean "is_finished"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "match_states", force: :cascade do |t|
    t.integer "match_id"
    t.integer "game_state_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "matches", force: :cascade do |t|
    t.integer "winner_id"
    t.integer "loser_id"
    t.integer "game1_id"
    t.integer "game2_id"
    t.boolean "user1_handshake"
    t.boolean "user2_handshake"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.float "rank", default: 200.0
    t.boolean "logged_in"
    t.boolean "issued_challenge"
    t.datetime "last_activity"
    t.boolean "in_lobby"
    t.boolean "marked_inactive"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
