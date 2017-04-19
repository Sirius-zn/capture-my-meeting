class User < ActiveRecord::Base
	validates_presence_of :email, :password
	validates :email, uniqueness: true
	
	has_many :meeting_users
end
