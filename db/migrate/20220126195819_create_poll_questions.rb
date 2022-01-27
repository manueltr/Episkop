class CreatePollQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :poll_questions do |t|
      
      t.belongs_to :poll, foreign_key: true
      t.string :type
      t.text :content

      t.timestamps
    end
  end
end
