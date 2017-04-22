class Meeting < ActiveRecord::Base
	validates_presence_of :password
	validates_presence_of :code
    validates_presence_of :user

    belongs_to :user

	has_many :meeting_contents
	has_many :meeting_users

    def authenticate?(str)
        str == self.password
    end
end
