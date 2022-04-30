class AddAnonymousToPollVotes < ActiveRecord::Migration[7.0]
  def change
    add_column :poll_votes, :anonymous, :boolean
  end
end
