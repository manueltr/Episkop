require "test_helper"

class PollQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @poll_question = poll_questions(:one)
  end

  test "should get index" do
    get poll_questions_url
    assert_response :success
  end

  test "should get new" do
    get new_poll_question_url
    assert_response :success
  end

  test "should create poll_question" do
    assert_difference("PollQuestion.count") do
      post poll_questions_url, params: { poll_question: { content: @poll_question.content, type: @poll_question.type } }
    end

    assert_redirected_to poll_question_url(PollQuestion.last)
  end

  test "should show poll_question" do
    get poll_question_url(@poll_question)
    assert_response :success
  end

  test "should get edit" do
    get edit_poll_question_url(@poll_question)
    assert_response :success
  end

  test "should update poll_question" do
    patch poll_question_url(@poll_question), params: { poll_question: { content: @poll_question.content, type: @poll_question.type } }
    assert_redirected_to poll_question_url(@poll_question)
  end

  test "should destroy poll_question" do
    assert_difference("PollQuestion.count", -1) do
      delete poll_question_url(@poll_question)
    end

    assert_redirected_to poll_questions_url
  end
end
