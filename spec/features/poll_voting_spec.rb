require 'rails_helper'

RSpec.feature "PollVotes", type: :feature do

    before (:each) do
        @poll = Poll.create(:user_id => 1, :title => "Rspec poll voting testing", :summary => "This is a poll to test votes")

        @pollq1 = PollQuestion.create(:poll_id => @poll.id, :question_type => "Multiple Choice", :content => "What is your favorite place to get wings")
        @pollq2 = PollQuestion.create(:poll_id => @poll.id, :question_type => "Yes No", :content => "Do you like basketball")
        @pollq3 = PollQuestion.create(:poll_id => @poll.id, :question_type => "Input", :content => "What is your favorite game")

        PollAnswer.create(:poll_id => @poll.id, :poll_question_id => @pollq1.id, :content => "wingstop")
        PollAnswer.create(:poll_id => @poll.id, :poll_question_id => @pollq1.id, :content => "wings n more")

    end

    # describe "When I go to vote for a poll" do
    #     it "should take me to a poll form" do

    #       form_url(@poll.invite_token)
    #       visit poll_path(@poll)
    #       page.should have_content("test")
    #       page.should have_content("Add answer choice")
    #       click_on("Add answer choice")
    #       fill_in("Content", with: "test1")
    #       click_on("Create Poll answer")
    #       expect(page).to have_current_path(poll_path(@poll))
    #       expect(page).to have_content("test1")
    #     end
    #     it "should be able to destroy an answer choice" do
    #         PollAnswer.create(:poll_id => @poll.id, :poll_question_id => @pollq.id, :content => "test2")
    #         visit poll_path(@poll)
    #         expect(page).to have_content("delete")
    #         click_on("delete")
    #         expect(page).to have_no_content("test2")
    #     end
    # end

end