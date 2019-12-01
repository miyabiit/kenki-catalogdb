class AddStaffRoleToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :staff_role, :string, default: 'read'
  end
end
