class CreateAttendances < ActiveRecord::Migration[8.1]
  def change
    create_table :attendances do |t|
      t.references :activity, null: false, foreign_key: true
      t.datetime :scheduled_at, null: false
      t.string :status

      t.timestamps
    end
    
    add_index :attendances, [:activity_id, :scheduled_at], unique: true
  end
end
