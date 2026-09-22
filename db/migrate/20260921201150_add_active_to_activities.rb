class AddActiveToActivities < ActiveRecord::Migration[8.1]
  def change
    add_column :activities, :active, :boolean, default: true, null: false
  end
end
