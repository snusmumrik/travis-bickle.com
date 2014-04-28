class AddEdyToReport < ActiveRecord::Migration
  def change
    add_column :reports, :edy, :integer, :after => :ticket, :default => 0
  end
end
