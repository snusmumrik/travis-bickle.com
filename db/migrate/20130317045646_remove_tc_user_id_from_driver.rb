class RemoveTcUserIdFromDriver < ActiveRecord::Migration
  def up
    remove_column :drivers, :tc_user_id
  end

  def down
    add_column :drivers, :tc_user_id, :string, :after => :user_id
  end
end
