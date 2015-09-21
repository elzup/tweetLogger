class AddEmotionToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :emotion, :int
  end
end
