class CreateInspections < ActiveRecord::Migration
  def change
    create_table :inspections do |t|
      t.references :car
      t.date :date
      t.integer :span

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :inspections, :car_id
  end
end
