class CreateCheckPointStatuses < ActiveRecord::Migration
  def change
    create_table :check_point_statuses do |t|
      t.references :report
      t.references :check_point
      t.string :status

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :check_point_statuses, :report_id
    add_index :check_point_statuses, :check_point_id
  end
end
