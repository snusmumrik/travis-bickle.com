class CreateTransferSlips < ActiveRecord::Migration
  def change
    create_table :transfer_slips do |t|
      t.references :report
      t.string :debit
      t.integer :debit_amount
      t.string :credit
      t.integer :credit_amount
      t.string :note

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :transfer_slips, :report_id
  end
end
