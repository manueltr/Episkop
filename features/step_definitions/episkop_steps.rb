Given (/^I am on the home page$/) do 
    visit home_page
end  

When(/^I click Google Login$/) do
    within("#session") do
    fill_in 'Email', with: 'user@example.com'
  end
end

Then(/^I should see "([^"]*)"$/) do 
    expect(page).to.eql("Signed In") 
end

Given