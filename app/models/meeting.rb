class Meeting < ActiveRecord::Base
	validates_presence_of :password
	validates_presence_of :code

	has_many :meeting_contents
	has_many :meeting_users

    def authenticate(str)
        str == self.password
    end
end
