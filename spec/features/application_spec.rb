require 'rails_helper'

RSpec.feature "Applications", type: :feature do
  
  describe "When I go to the welcome page route" do
    it "should display the welcome page" do

      page.set_rack_session(:user_id => nil)
      visit "/?user=false"
      page.should have_content("Episkop")
      page.should have_content("Google Login")
      
    end

    

  end

  describe "When I go to the welcome page route" do
    it "should redirect me to my dashboard if I am already signed in" do
      visit root_path
      page.should have_content("My Polls")
      expect(page).to have_current_path(logged_in_path)
    end
  end

  describe "When I click the new poll link" do
    it "should take me to the poll creation page" do
      visit root_path
      click_on("New poll")
      expect(page).to have_current_path(new_poll_path)
    end

    it "should me a form" do
      visit new_poll_path
      page.should have_content("New poll")
      page.should have_content("Title")
      page.should have_content("Summary")
    end
  end
  
end
