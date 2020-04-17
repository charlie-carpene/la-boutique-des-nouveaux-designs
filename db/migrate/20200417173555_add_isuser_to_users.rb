class AddIsuserToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_maker, :boolean, :default => false
  end
end
