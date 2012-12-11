class AddWorkHoursToReport < ActiveRecord::Migration
  def change
    add_column :reports, :started_at, :datetime, :after => :advance
    add_column :reports, :finished_at, :datetime, :after => :started_at
  end
end
