require 'test_helper'

class MeetingContentTest < ActiveSupport::TestCase
	def setup
		@mc = MeetingContent.new(:meeting_id => 31, :image => "blob")
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
