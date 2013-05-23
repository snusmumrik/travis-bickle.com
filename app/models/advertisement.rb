class Advertisement < ActiveRecord::Base
  attr_accessible :deleted_at, :name, :youtube_videoid
end
