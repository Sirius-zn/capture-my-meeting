class MeetingUser < ActiveRecord::Base
	validates_presence_of :user_id
	validates_presence_of :meeting_id
    validates_presence_of :user_role

    validates :user_role, inclusion: { in: %w(presenter audience), message: "%(value) is not a valid role" }

	belongs_to :user
	belongs_to :meeting
end
