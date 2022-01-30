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

end
