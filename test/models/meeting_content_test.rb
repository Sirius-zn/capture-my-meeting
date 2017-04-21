require 'test_helper'

class MeetingContentTest < ActiveSupport::TestCase
	def setup
        @user = User.new(:email => "ex@example.com", :password => "aa")
        @user.save!
		@meeting = Meeting.new(:code => "abcd", :password => "6GCBLY", :user_id => @user.id)
		@meeting.save!
		@mc = MeetingContent.new(:meeting_id => @meeting.id, :image => "blob")
	end

	test "should be valid" do
		assert @mc.valid?
	end

	test "meeting_id should exist" do
		@mc.meeting_id = nil
		assert_not @mc.valid?
	end

	test "image blob should exist" do
		@mc.image = nil
		assert_not @mc.valid?
	end
end
