require "application_system_test_case"

class PollQuestionsTest < ApplicationSystemTestCase
  setup do
    @poll_question = poll_questions(:one)
  end

  test "visiting the index" do
    visit poll_questions_url
    assert_selector "h1", text: "Poll questions"
  end

  test "should create poll question" do
    visit poll_questions_url
    click_on "New poll question"

    fill_in "Content", with: @poll_question.content
    fill_in "Type", with: @poll_question.type
    click_on "Create Poll question"

    assert_text "Poll question was successfully created"
    click_on "Back"
  end

  test "should update Poll question" do
    visit poll_question_url(@poll_question)
    click_on "Edit this poll question", match: :first

    fill_in "Content", with: @poll_question.content
    fill_in "Type", with: @poll_question.type
    click_on "Update Poll question"

    assert_text "Poll question was successfully updated"
    click_on "Back"
  end

  test "should destroy Poll question" do
    visit poll_question_url(@poll_question)
    click_on "Destroy this poll question", match: :first

    assert_text "Poll question was successfully destroyed"
  end
end
