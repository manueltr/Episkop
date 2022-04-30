require 'rails_helper'

RSpec.feature "PollQuestions", type: :feature do

  before (:each) do
    @poll = Poll.create(:user_id => 1, :title => "Rspec question testing", :summary => "This is a poll to test questions")
  end

  describe "When I go to the poll show" do
    it "should show me all the questions associated with that poll" do
      PollQuestion.create(:poll_id => @poll.id, :question_type => "Input", :content => "Testing show of questions")
      visit poll_main_page_url(@poll.invite_token)
      page.should have_content("Testing show of questions")
    end

    it "should allow me to click on show this question" do
      poll_question = PollQuestion.create(:poll_id => @poll.id, :question_type => "Input", :content => "Testing show of questions")
      visit poll_main_page_url(@poll.invite_token)
      click_link("Show this poll question")
      page.should have_content("Testing show of questions")
      expect(page).to have_current_path(poll_question_path(poll_question))
    end

    it "should allow me to create a new question" do
      visit poll_main_page_url(@poll.invite_token)
      click_button("Add a question")
      select('Yes No', :from => 'Question type')
      fill_in('Question Content', with: 'new question')
      click_button("Create Poll question")
      page.should have_content("new question")
      page.should have_content("Yes")
      page.should have_content("No")
      expect(page).to have_current_path(poll_main_page_url(@poll.invite_token))
    end
  end

  describe "When I am on the show poll question page" do
    it "should allow me to delete the question and redirect me to the poll show page" do
      poll_question = PollQuestion.create(:poll_id => @poll.id, :question_type => "Input", :content => "Testing show of questions")
      visit poll_question_path(poll_question)
      click_button("Destroy this poll question")
      page.should have_no_content('Testing show of questions')
      page.should have_current_path(poll_main_page_url(@poll.invite_token))
    end

    it "should allow me to edit a question and redirect me to the poll show page once submitted" do
      poll_question = PollQuestion.create(:poll_id => @poll.id, :question_type => "Input", :content => "Testing show of questions")
      visit poll_question_path(poll_question)
      click_link("Edit this poll question")
      fill_in('Content', with: "Rspec poll_question updated")
      click_button("Update Poll question")
      page.should have_content("Rspec poll_question updated")
      page.should have_current_path(poll_main_page_url(@poll.invite_token))
    end


  end

  


end
