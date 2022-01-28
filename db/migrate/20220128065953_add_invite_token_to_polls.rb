class AddInviteTokenToPolls < ActiveRecord::Migration[7.0]
  def change
    add_column :polls, :invite_token, :string
    add_index :polls, :invite_token, unique: true
  end
end
