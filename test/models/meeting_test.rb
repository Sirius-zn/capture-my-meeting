require 'test_helper'

class MeetingTest < ActiveSupport::TestCase
	def setup
		@meeting = Meeting.new(:password => "pass", :code => "code")
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
end
