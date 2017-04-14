class CreateMeetings < ActiveRecord::Migration[5.0]
  def change
    create_table :meetings do |t|
      t.string :password
      t.string :code

      t.timestamps
    end
  end
end
