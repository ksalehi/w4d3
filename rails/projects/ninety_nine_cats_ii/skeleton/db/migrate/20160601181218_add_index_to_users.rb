class AddIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :session_token
  end
end
