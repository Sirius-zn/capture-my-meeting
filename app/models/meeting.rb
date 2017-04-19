class Meeting < ActiveRecord::Base
	validates_presence_of :password, :code
end
