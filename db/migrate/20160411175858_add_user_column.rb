class AddUserColumn < ActiveRecord::Migration
  def change
    add_column :records, :user_id, :integer
  end
end
