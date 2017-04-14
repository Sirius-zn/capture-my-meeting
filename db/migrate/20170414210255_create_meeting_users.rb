class CreateMeetingUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :meeting_users do |t|
      t.integer :user_id
      t.integer :meeting_id

      t.timestamps
    end
  end
end
