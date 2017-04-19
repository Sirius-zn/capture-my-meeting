class MeetingContent < ActiveRecord::Base
	validates_presence_of :meeting_id, :image

	belongs_to :meeting
end
