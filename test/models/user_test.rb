require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = User.new(:email => "example@email.com", :password => "pass")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "should have an email" do
		@user.email = nil
		assert_not @user.valid?
	end

	test "should have a password" do
		@user.password = nil
		assert_not @user.valid?
	end

end
