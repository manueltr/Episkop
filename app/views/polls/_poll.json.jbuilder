json.extract! poll, :id, :title, :summary, :opened, :ends_at, :created_at, :updated_at, :publish, :directory_id
json.url poll_url(poll, format: :json)
json.invite_token poll.invite_token
json.poll_questions(poll_questions) do |poll_question|
    json.partial! "poll_questions/poll_question", poll_question: poll_question
end