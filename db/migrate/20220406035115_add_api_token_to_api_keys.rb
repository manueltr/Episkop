class AddApiTokenToApiKeys < ActiveRecord::Migration[7.0]
  def change
    add_column :api_keys, :api_token, :string
    add_index :api_keys, :api_token, unique: true
  end
end
