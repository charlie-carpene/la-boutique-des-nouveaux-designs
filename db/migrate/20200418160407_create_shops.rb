class CreateShops < ActiveRecord::Migration[6.0]
  def change
    create_table :shops do |t|
      t.belongs_to :user, foreign_key: true
      t.string :brand
      t.string :website
      t.text :description

      t.timestamps
    end
  end
end
