class CreateApps < ActiveRecord::Migration[7.0]
  def change
    create_table :apps do |t|
      t.string :token
      t.string :name, null: false

      t.timestamps
    end
    add_index :apps, :token, unique: true
  end
end
