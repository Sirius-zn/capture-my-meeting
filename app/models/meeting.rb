class Meeting < ActiveRecord::Base
	validates_presence_of :password, :code

	has_many :meeting_contents, :meeting_users
end
