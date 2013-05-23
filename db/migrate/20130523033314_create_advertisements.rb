class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.string :name
      t.string :youtube_videoid
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
