class RemoveTypeFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :type, :string
  end
end