class ChangingApiTable < ActiveRecord::Migration[7.0]
  def change
    add_column :api_keys, :create_key, :boolean
    add_column :api_keys, :delete_key, :boolean
    add_column :api_keys, :extract_key, :boolean
    add_column :api_keys, :edit_key, :boolean

    remove_column :api_keys, :purpose
  end
end
