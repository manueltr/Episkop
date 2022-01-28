json.extract! poll_answer, :id, :content, :created_at, :updated_at
json.url poll_answer_url(poll_answer, format: :json)
