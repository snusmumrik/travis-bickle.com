class CreateBreaks < ActiveRecord::Migration
  def change
    create_table :breaks do |t|
      t.references :report
      t.float :latitude
      t.float :longitude
      t.datetime :ended_at
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :breaks, :report_id
  end
end
