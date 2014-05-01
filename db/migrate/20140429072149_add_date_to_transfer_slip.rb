class AddDateToTransferSlip < ActiveRecord::Migration
  def change
    add_column :transfer_slips, :user_id, :integer, :after => :id
    add_column :transfer_slips, :date, :date, :after => :report_id
    add_column :transfer_slips, :whole_day, :boolean, :after => :note
  end
end
