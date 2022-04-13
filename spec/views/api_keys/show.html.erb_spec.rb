require 'rails_helper'

RSpec.describe "api_keys/show", type: :view do
  before(:each) do
    @api_key = assign(:api_key, ApiKey.create!(
      purpose: "Purpose",
      in_req_mode: "In Req Mode",
      accepted: "Accepted",
      explanation: "Explanation"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Purpose/)
    expect(rendered).to match(/In Req Mode/)
    expect(rendered).to match(/Accepted/)
    expect(rendered).to match(/Explanation/)
  end
end
