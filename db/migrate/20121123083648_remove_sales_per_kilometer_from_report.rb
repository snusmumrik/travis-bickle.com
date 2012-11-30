class RemoveSalesPerKilometerFromReport < ActiveRecord::Migration
  def up
    remove_column :reports, :sales_par_kilometer
  end

  def down
    add_column :reports, :sales_par_kilometer, :integer, :after => :sales
  end
end




