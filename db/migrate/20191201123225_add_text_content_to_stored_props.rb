class AddTextContentToStoredProps < ActiveRecord::Migration[6.0]
  def change
    add_column :stored_props, :text_content, :text
  end
end
