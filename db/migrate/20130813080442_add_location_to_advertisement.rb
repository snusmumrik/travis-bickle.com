class AddLocationToAdvertisement < ActiveRecord::Migration
  def change
    add_column :advertisements, :location, :string, :after => :youtube_videoid
    add_column :advertisements, :latitude, :float, :after => :location
    add_column :advertisements, :longitude, :float, :after => :latitude
    add_column :advertisements, :gmaps, :boolean, :after => :longitude, :default => true
  end
end
