require 'test_helper'

class MeetingTest < ActiveSupport::TestCase
	def setup
        @user = User.new(:email => "ex@example.com", :password => "pass")
        @user.save!
		@meeting = Meeting.new(:password => "pass", :code => "code", :user_id => @user.id)
	end

	test "should be valid" do
		assert @meeting.valid?
	end

	test "password should be present" do
		@meeting.password = nil
		assert_not @meeting.valid?
	end

	test "code should be present" do
		@meeting.code = nil
		assert_not @meeting.valid?
	end

    test "user_id should be present" do
        @meeting.user_id = nil
        assert_not @meeting.valid?
    end
end
