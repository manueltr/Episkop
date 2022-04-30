require 'rails_helper'

RSpec.feature "PollAnswers", type: :feature do
    before (:each) do
        @poll = Poll.create(:user_id => 1, :title => "Rspec answer testing", :summary => "This is a poll to test answers")
        @pollq = PollQuestion.create(:poll_id => @poll.id, :question_type => "Multiple Choice", :content => "test")
    end
    
    describe "When I go to a poll page" do
      
        it "should all me to create an answer choice" do
          visit poll_main_page_url(@poll.invite_token)
          page.should have_content("Add Answer Choice")
          click_on("Add Answer Choice")
          fill_in("Answer Content", with: "test1")
          click_on("Create Poll answer")
          expect(page).to have_current_path(poll_main_page_url(@poll.invite_token))
          expect(page).to have_content("test1")
        end

        it "should be able to destroy an answer choice" do

            @poll_answer = PollAnswer.create(:poll_id => @poll.id, :poll_question_id => @pollq.id, :content => "howdy")
            visit poll_main_page_url(@poll.invite_token)
            expect(page).to have_content("howdy")
            href = page.evaluate_script("$('a.link_class').attr('href');")
            expect(page.html).to have_css('.delete_answer_icon[data-*="'+@poll_answer.id.to_s+'"]')
            find(:css, ".delete_answer_icon").click
            visit poll_path(@poll)
            expect(page).to have_no_content("howdy")
        end
    end

end