class AddSubmittedAttributeToPollVote < ActiveRecord::Migration[7.0]
  def change
    add_column :poll_votes, :submitted, :boolean
  end
end
