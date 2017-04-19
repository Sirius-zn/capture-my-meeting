class MeetingUser < ActiveRecord::Base
	validates_presence_of :user_id, :meeting_id
end
