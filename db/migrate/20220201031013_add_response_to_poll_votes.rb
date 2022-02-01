class AddResponseToPollVotes < ActiveRecord::Migration[7.0]
  def change
    add_column :poll_votes, :response, :text
  end
end
