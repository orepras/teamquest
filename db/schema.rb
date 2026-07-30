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

ActiveRecord::Schema[8.0].define(version: 2026_07_30_054949) do
  create_table "character_skills", force: :cascade do |t|
    t.integer "character_id", null: false
    t.integer "skill_id", null: false
    t.string "tier", default: "novice", null: false
    t.integer "skill_xp", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "skill_id"], name: "index_character_skills_on_character_id_and_skill_id", unique: true
    t.index ["character_id"], name: "index_character_skills_on_character_id"
    t.index ["skill_id"], name: "index_character_skills_on_skill_id"
  end

  create_table "characters", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.string "character_class", null: false
    t.string "subclass"
    t.string "title"
    t.string "avatar"
    t.text "backstory"
    t.integer "strength", default: 5, null: false
    t.integer "intellect", default: 5, null: false
    t.integer "wisdom", default: 5, null: false
    t.integer "dexterity", default: 5, null: false
    t.integer "charisma", default: 5, null: false
    t.integer "constitution", default: 5, null: false
    t.integer "xp_total", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_characters_on_user_id", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "character_id", null: false
    t.integer "team_id", null: false
    t.string "role", default: "member", null: false
    t.datetime "left_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "team_id"], name: "index_memberships_on_character_id_and_team_id", unique: true
    t.index ["character_id"], name: "index_memberships_on_character_id"
    t.index ["team_id"], name: "index_memberships_on_team_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_skills_on_name", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "crest"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "xp_grant_recipients", force: :cascade do |t|
    t.integer "xp_grant_id", null: false
    t.integer "character_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_xp_grant_recipients_on_character_id"
    t.index ["xp_grant_id"], name: "index_xp_grant_recipients_on_xp_grant_id"
  end

  create_table "xp_grants", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "granter_id", null: false
    t.string "category", null: false
    t.integer "amount", null: false
    t.text "note"
    t.datetime "voided_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["granter_id"], name: "index_xp_grants_on_granter_id"
    t.index ["team_id"], name: "index_xp_grants_on_team_id"
  end

  add_foreign_key "character_skills", "characters"
  add_foreign_key "character_skills", "skills"
  add_foreign_key "characters", "users"
  add_foreign_key "memberships", "characters"
  add_foreign_key "memberships", "teams"
  add_foreign_key "sessions", "users"
  add_foreign_key "xp_grant_recipients", "characters"
  add_foreign_key "xp_grant_recipients", "xp_grants"
  add_foreign_key "xp_grants", "characters", column: "granter_id"
  add_foreign_key "xp_grants", "teams"
end
