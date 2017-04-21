require 'test_helper'

class MeetingUserTest < ActiveSupport::TestCase
	def setup
		@user = User.new(:email => "user@example.com", :password => "a1!Abbf3s/~!")
		@user.save!

		@meeting = Meeting.new(:code => "abcd", :password => "6GCBLY", :user_id => @user.id)
		@meeting.save!

		@mu = MeetingUser.new(user_id: @user.id, meeting_id: @meeting.id)
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
