class Advertisement < ActiveRecord::Base
  attr_accessible :deleted_at, :name, :youtube_videoid
  acts_as_paranoid
end
