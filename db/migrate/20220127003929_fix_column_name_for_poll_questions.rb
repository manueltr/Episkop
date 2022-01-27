class FixColumnNameForPollQuestions < ActiveRecord::Migration[7.0]
  def change
    rename_column :poll_questions, :type, :question_type
  end
end
