class AddExtraSalesToReport < ActiveRecord::Migration
  def change
    add_column :reports, :extra_sales, :integer, :after => :sales, :default => 0
  end
end
