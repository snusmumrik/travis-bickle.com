class AddDeletedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :datetime, :after => :last_sign_in_at
  end
end
