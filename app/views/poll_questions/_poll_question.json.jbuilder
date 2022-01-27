json.extract! poll_question, :id, :question_type, :content, :created_at, :updated_at
json.url poll_question_url(poll_question, format: :json)
