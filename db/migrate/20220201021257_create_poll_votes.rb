class CreatePollVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :poll_votes do |t|

      t.belongs_to :user, foreign_key: true
      t.belongs_to :poll, foreign_key: true
      t.belongs_to :poll_question, foreign_key: true
      t.belongs_to :poll_answer, foreign_key: true
    end
  end
end
