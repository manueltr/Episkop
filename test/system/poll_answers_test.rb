require "application_system_test_case"

class PollAnswersTest < ApplicationSystemTestCase
  setup do
    @poll_answer = poll_answers(:one)
  end

  test "visiting the index" do
    visit poll_answers_url
    assert_selector "h1", text: "Poll answers"
  end

  test "should create poll answer" do
    visit poll_answers_url
    click_on "New poll answer"

    fill_in "Content", with: @poll_answer.content
    click_on "Create Poll answer"

    assert_text "Poll answer was successfully created"
    click_on "Back"
  end

  test "should update Poll answer" do
    visit poll_answer_url(@poll_answer)
    click_on "Edit this poll answer", match: :first

    fill_in "Content", with: @poll_answer.content
    click_on "Update Poll answer"

    assert_text "Poll answer was successfully updated"
    click_on "Back"
  end

  test "should destroy Poll answer" do
    visit poll_answer_url(@poll_answer)
    click_on "Destroy this poll answer", match: :first

    assert_text "Poll answer was successfully destroyed"
  end
end
