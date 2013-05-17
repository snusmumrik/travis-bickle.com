class RemoveMeterFromReports < ActiveRecord::Migration
  def up
    remove_column :reports, :meter
  end

  def down
    add_column :reports, :meter, :integer, :after => :date
  end
end
