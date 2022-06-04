class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.integer :number
      t.string :app_token

      t.timestamps
    end
    add_index :chats, :app_token
  end
end
