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

ActiveRecord::Schema[8.1].define(version: 2026_09_21_231341) do
  create_table "activities", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "end_time"
    t.string "name"
    t.datetime "start_time"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "attendances", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "original_scheduled_at"
    t.integer "recurring_schedule_id"
    t.string "schedule_state", default: "planned", null: false
    t.datetime "scheduled_at", null: false
    t.datetime "scheduled_ends_at"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["activity_id", "scheduled_at"], name: "index_attendances_on_activity_id_and_scheduled_at", unique: true
    t.index ["activity_id"], name: "index_attendances_on_activity_id"
    t.index ["recurring_schedule_id"], name: "index_attendances_on_recurring_schedule_id"
    t.check_constraint "schedule_state IN ('planned', 'rescheduled', 'cancelled')", name: "attendances_valid_schedule_state"
    t.check_constraint "status IS NULL OR status IN ('early', 'on-time', 'late', 'missed')", name: "attendances_valid_status"
  end

  create_table "recurring_schedules", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.datetime "created_at", null: false
    t.date "effective_from", null: false
    t.date "effective_until"
    t.time "ends_at"
    t.time "starts_at"
    t.datetime "updated_at", null: false
    t.integer "weekday", null: false
    t.index ["activity_id"], name: "index_recurring_schedules_on_activity_id"
    t.check_constraint "effective_until IS NULL OR effective_until >= effective_from", name: "recurring_schedules_valid_period"
    t.check_constraint "ends_at IS NULL OR starts_at IS NOT NULL", name: "recurring_schedules_end_requires_start"
    t.check_constraint "weekday BETWEEN 1 AND 7", name: "recurring_schedules_weekday_range"
  end

  add_foreign_key "attendances", "activities"
  add_foreign_key "attendances", "recurring_schedules"
  add_foreign_key "recurring_schedules", "activities"
end
