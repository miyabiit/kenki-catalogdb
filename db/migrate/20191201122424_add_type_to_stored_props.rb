class AddTypeToStoredProps < ActiveRecord::Migration[6.0]
  def change
    add_column :stored_props, :type, :string, default: 'TextProp'
  end
end
