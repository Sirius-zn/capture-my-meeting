class MeetingContent < ActiveRecord::Base
  validates_presence_of :meeting_id, :image
end
