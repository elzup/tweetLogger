class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :tweet_id, :limit => 8
      t.timestamp :tweet_created_at
      t.float :lat
      t.float :lon

      t.timestamps null: false
    end
  end
end
