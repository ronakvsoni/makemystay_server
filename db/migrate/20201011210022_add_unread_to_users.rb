class AddUnreadToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :unread, :integer, default: 1
  end
end
