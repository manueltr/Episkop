require 'rails_helper'

RSpec.describe Poll, type: :model do

  subject {
    described_class.new(
      id: 1,
      user_id: 1,
      title:"test subject poll",
      summary:"this poll is for test cases",
      opened:false,
      ends_at:DateTime.now + 1,
      created_at:DateTime.now,
      updated_at:DateTime.now,
      publish:false
    )
  }

  it "is not valid without a title" do
    subject.title = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a summary" do
    subject.summary = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a user" do
    subject.user = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without an opened" do
    subject.opened = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a published" do
    subject.publish = nil
    expect(subject).to_not be_valid
  end

  # it "is valid without an ends_at if published false" do
  #   subject.publish = false
  #   subject.ends_at = nil
  #   expect(subject).to be_valid
  # end
  
end
