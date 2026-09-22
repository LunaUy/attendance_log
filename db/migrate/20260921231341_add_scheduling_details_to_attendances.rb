class AddSchedulingDetailsToAttendances < ActiveRecord::Migration[8.1]
  def change
    add_reference :attendances, :recurring_schedule, null: true, foreign_key: true
    add_column :attendances, :original_scheduled_at, :datetime
    add_column :attendances, :scheduled_ends_at, :datetime
    add_column :attendances, :schedule_state, :string, null: false, default: "planned"
    
    add_check_constraint :attendances, "schedule_state IN ('planned', 'rescheduled', 'cancelled')", name: "attendances_valid_schedule_state"
    add_check_constraint :attendances, "status IS NULL OR status IN ('early', 'on-time', 'late', 'missed')", name: "attendances_valid_status"
  end
end
