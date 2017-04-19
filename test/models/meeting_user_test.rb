require 'test_helper'

class MeetingUserTest < ActiveSupport::TestCase
	def setup
		@mu = MeetingUser.new(user_id: 31, meeting_id: 3)		
	end
	
	test "should be valid" do
		assert @mu.valid?
	end


	test "user_id should be present" do
		@mu.user_id = nil
		assert_not @mu.valid?
	end
	
	test "meeting_id should be present" do
		@mu.meeting_id = nil
		assert_not @mu.valid?
	end

end
