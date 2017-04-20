class User < ActiveRecord::Base
	validates_presence_of :email
	validates_presence_of :password

	validates :email, uniqueness: true
	
	has_many :meeting_users

	def authenticate(pass)
		self.password == pass
	end
end
