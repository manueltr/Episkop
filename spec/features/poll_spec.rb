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
    it "should take me to the sho"
  end

end
