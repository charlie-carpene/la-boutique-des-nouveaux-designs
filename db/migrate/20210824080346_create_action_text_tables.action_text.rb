# This migration comes from action_text (originally 20180528164100)
class CreateActionTextTables < ActiveRecord::Migration[6.0]
  def change
    create_table :action_text_rich_texts do |t|
      t.string     :name, null: false
      t.text       :body, size: :long
      t.references :record, null: false, polymorphic: true, index: false

      t.timestamps

      t.index [ :record_type, :record_id, :name ], name: "index_action_text_rich_texts_uniqueness", unique: true
    end

    reversible do |dir|
      dir.up do
        Item.find_each do |item|
          item.rich_description = item.description
          item.save
        end
      end

      dir.down do
        Item.find_each do |item|
          unless item.rich_description.body.blank?
            item.description = item.rich_description.body.to_plain_text
            item.save
          end
        end
      end
    end

    remove_column :items, :description, :text, default: ''
  end
end
