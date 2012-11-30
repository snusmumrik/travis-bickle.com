class CreateRests < ActiveRecord::Migration
  def change
    create_table :rests do |t|
      t.references :report
      t.string :location
      t.float :latitude
      t.float :longitude
      t.datetime :started_at
      t.datetime :ended_at
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :rests, :report_id
  end
end
