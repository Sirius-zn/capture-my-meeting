class AddUserIdToMeetingsTable < ActiveRecord::Migration[5.0]
  def change
    add_column :meetings, :user_id, :string
  end
end
