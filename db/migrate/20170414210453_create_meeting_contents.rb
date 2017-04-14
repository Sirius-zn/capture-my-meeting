class CreateMeetingContents < ActiveRecord::Migration[5.0]
  def change
    create_table :meeting_contents do |t|
      t.integer :meeting_id
      t.binary :image

      t.timestamps
    end
  end
end
