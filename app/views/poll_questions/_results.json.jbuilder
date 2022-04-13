
json.question_type == poll_question.question_type
if poll_question.question_type == "Input"
    json.data poll_question.get_graph_data
else
    json.data(poll_question.poll_answers) do |poll_answer|
        json.label poll_answer.content
        json.value poll_answer.poll_votes.count 
    end
end