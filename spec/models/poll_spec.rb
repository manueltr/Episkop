require 'rails_helper'

RSpec.describe Poll, type: :model do

  it "is valid with valid attributes" do
    expect(Poll.new).to be_valid
  end

  it "is not valid without a title" do 
    poll = Poll.new(title: nil)
    expect(poll).to_not be_valid
  end

  it "is not valid without a summary" do
    poll = Poll.new(summary: nil)
    expect(poll).to_not be_valid
  end

  it "is valid without an opened" do
    poll = Poll.new(opened: nil)
    expect(poll).to be_valid
  end

  it "is valid without a published" do
    poll = Poll.new(published: nil)
    expect(poll).to be_valid
  end

  it "is valid without an end datetime" do
    poll = Poll.new(ends_at: nil)
    expect(poll).to be_valid
  end
  
end
