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

ActiveRecord::Schema.define(version: 20140404002132) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "card_decks", force: true do |t|
    t.integer  "user_id",                    null: false
    t.integer  "hero_id",                    null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "num_games_won",  default: 0
    t.integer  "num_games_lost", default: 0
  end

  add_index "card_decks", ["user_id"], name: "index_card_decks_on_user_id", using: :btree

  create_table "card_decks_cards", id: false, force: true do |t|
    t.integer "card_deck_id", null: false
    t.integer "card_id",      null: false
  end

  add_index "card_decks_cards", ["card_deck_id"], name: "index_card_decks_cards_on_card_deck_id", using: :btree

  create_table "cards", force: true do |t|
    t.string   "name",       null: false
    t.string   "card_text"
    t.string   "card_type",  null: false
    t.integer  "mana"
    t.integer  "health"
    t.integer  "hero_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "damage"
    t.string   "rarity"
  end

  create_table "games", force: true do |t|
    t.integer  "user_id",      null: false
    t.integer  "card_deck_id", null: false
    t.integer  "hero_id",      null: false
    t.string   "mode",         null: false
    t.boolean  "win_ind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["card_deck_id"], name: "index_games_on_card_deck_id", using: :btree

  create_table "heroes", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "card_decks", "heroes", name: "card_decks_hero_id_fk"
  add_foreign_key "card_decks", "users", name: "card_decks_user_id_fk"

  add_foreign_key "card_decks_cards", "card_decks", name: "card_decks_cards_card_deck_id_fk"
  add_foreign_key "card_decks_cards", "cards", name: "card_decks_cards_card_id_fk"

  add_foreign_key "cards", "heroes", name: "cards_hero_id_fk"

  add_foreign_key "games", "card_decks", name: "games_card_deck_id_fk"
  add_foreign_key "games", "heroes", name: "games_hero_id_fk"
  add_foreign_key "games", "users", name: "games_user_id_fk"

end
