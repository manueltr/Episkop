require 'rails_helper'

RSpec.describe "api_keys/index", type: :view do
  before(:each) do
    assign(:api_keys, [
      ApiKey.create!(
        purpose: "Purpose",
        in_req_mode: "In Req Mode",
        accepted: "Accepted",
        explanation: "Explanation"
      ),
      ApiKey.create!(
        purpose: "Purpose",
        in_req_mode: "In Req Mode",
        accepted: "Accepted",
        explanation: "Explanation"
      )
    ])
  end

  it "renders a list of api_keys" do
    render
    assert_select "tr>td", text: "Purpose".to_s, count: 2
    assert_select "tr>td", text: "In Req Mode".to_s, count: 2
    assert_select "tr>td", text: "Accepted".to_s, count: 2
    assert_select "tr>td", text: "Explanation".to_s, count: 2
  end
end
