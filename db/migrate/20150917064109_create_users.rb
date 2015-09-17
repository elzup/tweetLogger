class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :twitter_user_id, limit:8

      t.timestamps null: false
    end
  end
end
