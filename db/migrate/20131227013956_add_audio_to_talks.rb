class AddAudioToTalks < ActiveRecord::Migration
  def change
    add_attachment :talks, :audio
  end
end
