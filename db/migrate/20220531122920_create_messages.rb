class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :text
      t.integer :chat_number
      t.string :app_token
      t.integer :number
      t.timestamps
    end

    add_index :messages, %i[app_token chat_number]
  end
end
