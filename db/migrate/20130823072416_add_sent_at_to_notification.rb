class AddSentAtToNotification < ActiveRecord::Migration
  def up
    remove_column :notifications, :read
    remove_column :notifications, :cancel
    add_column :notifications, :accepted_at, :datetime, :after => :text
    add_column :notifications, :canceled_at, :datetime, :after => :accepted_at
    add_column :notifications, :sent_at, :datetime, :after => :canceled_at
  end

  def down
    add_column :notifications, :read, :boolean, :after => :text
    add_column :notifications, :cancel, :boolean, :after => :read
    remove_column :notifications, :accepted_at
    remove_column :notifications, :canceled_at
    remove_column :notifications, :sent_at
  end
end
