class AddSourceIdToStoredProps < ActiveRecord::Migration[6.0]
  def change
    add_reference :stored_props, :source, null: true, index: true, foreign_key: false
  end
end
