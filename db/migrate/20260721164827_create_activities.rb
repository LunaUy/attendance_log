class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.string :name
      t.text :description
      t.string :status
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end