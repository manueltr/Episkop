class CreatePollAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :poll_answers do |t|
      t.string :content

      t.timestamps
    end
  end
end
