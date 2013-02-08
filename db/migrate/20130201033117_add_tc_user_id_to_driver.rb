class AddTcUserIdToDriver < ActiveRecord::Migration
  def change
    add_column :drivers, :tc_user_id, :string, :after => :user_id
  end
end
