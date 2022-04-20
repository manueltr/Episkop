json.extract! poll_question, :id, :question_type, :content, :created_at, :updated_at
json.url poll_question_url(poll_question, format: :json)
if poll_question.question_type != "Input"
    json.poll_answers(poll_answers) do |poll_answer|
    json.partial! "poll_answers/poll_answer", poll_answer: poll_answer
end
end
