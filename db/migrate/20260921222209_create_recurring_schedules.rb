class CreateRecurringSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :recurring_schedules do |t|
      t.references :activity, null: false, foreign_key: true
      t.integer :weekday, null: false
      t.time :starts_at
      t.time :ends_at
      t.date :effective_from, null:false
      t.date :effective_until

      t.timestamps
    end
  add_check_constraint :recurring_schedules, "weekday BETWEEN 1 AND 7", name: "recurring_schedules_weekday_range"
  add_check_constraint :recurring_schedules, "effective_until IS NULL OR effective_until >= effective_from", name: "recurring_schedules_valid_period"
  add_check_constraint :recurring_schedules, "ends_at IS NULL OR starts_at IS NOT NULL", name: "recurring_schedules_end_requires_start"
  end
end