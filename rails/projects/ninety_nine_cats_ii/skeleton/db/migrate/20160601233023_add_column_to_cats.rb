class AddColumnToCats < ActiveRecord::Migration
  def change
    add_column :cats, :user_id, :integer, null: false, index: true
  end
end
