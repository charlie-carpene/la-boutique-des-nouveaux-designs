class CreateTimestampedUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :timestamped_users do |t|
      t.string :email
      t.bigint :old_id

      t.timestamps
    end
  end
end
