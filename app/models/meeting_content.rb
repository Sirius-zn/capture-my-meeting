class MeetingContent < ActiveRecord::Base
	validates_presence_of :meeting_id
	validates_presence_of :image

	belongs_to :meeting
end
