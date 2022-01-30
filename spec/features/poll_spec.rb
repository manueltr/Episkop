require 'rails_helper'

RSpec.feature "Polls", type: :feature do
  
  describe "When I go to the new create poll page" do
    it "should show me a form to fill in" do
      visit new_poll_path
      page.should have_content("New poll")
    end
  end

  describe "When I create a new poll" do
    it "should warn me that a poll needs a title and summary when I try to create one without those attributes" do
      visit new_poll_path
      click_button("Create Poll")
      page.should have_content("Title can't be blank")
      page.should have_content("Summary can't be blank")
    end

    it "should create a new poll in the database and show it in my dashboard" do
      visit new_poll_path
      fill_in('Title', with: "Rspec poll")
      fill_in('Summary', with: "creating a new poll for testing")
      click_button("Create Poll")
      expect(page).to have_current_path(logged_in_path)
      page.should have_content("Rspec poll")
    end
  end

  describe "When I click show this poll link" do
    it "should take me to the show page" do
      Poll.create(:user_id => 1, :title => "Rspec poll", 
        :summary => "This is a poll to test show")
      visit logged_in_path
      click_link("Show this poll")
      expect(page).to have_current_path(poll_path(Poll.find_by(:title => "Rspec poll")))
    end
  end

  describe "When I am on the show page" do
    it "I should be able to delete the poll and be redirected to the homepage" do
      Poll.create(:user_id => 1, :title => "Rspec poll deletion", 
        :summary => "This is a poll to test show")
      visit poll_path(Poll.find_by(:title => "Rspec poll deletion"))
      click_button("Destroy this poll")
      expect(Poll.find_by(:title => "Rspec poll deletion")).to eq(nil)
      expect(page).to have_current_path(logged_in_path)
    end
  end

  describe "When I go to a poll that is not mine" do
    it "should redirect me to the homepage" do

      poll = Poll.create(:user_id => 2, :title => "Rspec poll authentication", 
        :summary => "This is a poll to test poll authentication")
      visit poll_path(poll)
      expect(page).to have_current_path(logged_in_path)
    end

    it "should show me a warning that the poll doesn't belong to me" do

      poll = Poll.create(:user_id => 3, :title => "Rspec wrong user poll", :summary => "This poll is to test authentication")
      visit poll_path(poll)
      expect(page).to have_content("That poll doesn't belong to you!")
    end 
  end

  describe "When I update a poll" do
    it "should the update changes" do
      poll = Poll.create(:user_id => 1, :title => "Rspec edit", :summary => "This poll is to test updating a poll", publish:true, ends_at:DateTime.now + 1)
      visit poll_path(poll)
      click_link("Edit this poll")
      fill_in('Title', with: "Rspec updated")
      click_button("Update Poll")
      expect(page).to have_content("Rspec updated")
      expect(page).to have_content("Poll was successfully updated.")
    end
  end

end
