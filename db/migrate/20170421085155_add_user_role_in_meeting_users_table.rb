class AddUserRoleInMeetingUsersTable < ActiveRecord::Migration[5.0]
  def change
      add_column :meeting_users, :user_role, :string
  end
end
