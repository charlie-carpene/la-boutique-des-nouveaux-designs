class CreateMakers < ActiveRecord::Migration[6.0]
  def change
    create_table :makers do |t|
      t.belongs_to :user, index: true
      t.string :brand
      t.string :website
      t.text :description

      t.timestamps
    end
  end
end
