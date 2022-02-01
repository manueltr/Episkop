require 'rails_helper'

RSpec.feature "PollAnswers", type: :feature do
    before (:each) do
        @poll = Poll.create(:user_id => 1, :title => "Rspec answer testing", :summary => "This is a poll to test answers")
        @pollq = PollQuestion.create(:poll_id => @poll.id, :question_type => "Multiple Choice", :content => "test")
    end
    describe "When I go to a poll page" do
        it "should be able to create an answer choice" do
          visit poll_path(@poll)
          page.should have_content("test")
          page.should have_content("Add answer choice")
          click_on("Add answer choice")
          fill_in("Content", with: "test1")
          click_on("Create Poll answer")
          expect(page).to have_current_path(poll_path(@poll))
          expect(page).to have_content("test1")
        end
        it "should be able to destroy an answer choice" do
            PollAnswer.create(:poll_id => @poll.id, :poll_question_id => @pollq.id, :content => "test2")
            visit poll_path(@poll)
            expect(page).to have_content("delete")
            click_on("delete")
            expect(page).to have_no_content("test2")
        end
    end

end