json.poll_id poll.id
json.poll_token poll.invite_token
json.title poll.title
json.summary poll.summary
json.question_count poll.poll_questions.count

json.results(poll.poll_questions) do |poll_question|

    json.question_id poll_question.id
    json.question_type poll_question.question_type
    json.question_title poll_question.content
    if poll_question.question_type == "Input"
        json.data_count 1
        json.data poll_question.get_graph_data
    else
        json.data_count poll_question.poll_answers.count
        json.data(poll_question.poll_answers) do |poll_answer|
            json.label poll_answer.content
            json.value poll_answer.poll_votes.count 
        end
    end
end