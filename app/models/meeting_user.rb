class MeetingUser < ActiveRecord::Base
	validates_presence_of :user_id
	validates_presence_of :meeting_id

	belongs_to :user
	belongs_to :meeting
end
