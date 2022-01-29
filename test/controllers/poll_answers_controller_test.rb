require "test_helper"

class PollAnswersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @poll_answer = poll_answers(:one)
  end

  test "should get index" do
    get poll_answers_url
    assert_response :success
  end

  test "should get new" do
    get new_poll_answer_url
    assert_response :success
  end

  test "should create poll_answer" do
    assert_difference("PollAnswer.count") do
      post poll_answers_url, params: { poll_answer: { content: @poll_answer.content } }
    end

    assert_redirected_to poll_answer_url(PollAnswer.last)
  end

  test "should show poll_answer" do
    get poll_answer_url(@poll_answer)
    assert_response :success
  end

  test "should get edit" do
    get edit_poll_answer_url(@poll_answer)
    assert_response :success
  end

  test "should update poll_answer" do
    patch poll_answer_url(@poll_answer), params: { poll_answer: { content: @poll_answer.content } }
    assert_redirected_to poll_answer_url(@poll_answer)
  end

  test "should destroy poll_answer" do
    assert_difference("PollAnswer.count", -1) do
      delete poll_answer_url(@poll_answer)
    end

    assert_redirected_to poll_answers_url
  end
end
