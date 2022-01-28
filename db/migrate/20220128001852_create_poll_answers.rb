class CreatePollAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :poll_answers do |t|
      
      t.belongs_to :poll, foreign_key: true
      t.belongs_to :poll_question, foreign_key: true
      t.string :content

      t.timestamps
    end
  end
end
