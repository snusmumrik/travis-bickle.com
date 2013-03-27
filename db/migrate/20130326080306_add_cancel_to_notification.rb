class AddCancelToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :cancel, :boolean, :after => :read
  end
end
