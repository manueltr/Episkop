require 'rails_helper'

RSpec.describe "api_keys/index", type: :view do
  before(:each) do
    assign(:api_keys, [
      ApiKey.create!(
        key_val: "Key Val",
        u_id: "U",
        purpose: "Purpose",
        in_request_mode: "In Request Mode",
        accepted: "Accepted"
      ),
      ApiKey.create!(
        key_val: "Key Val",
        u_id: "U",
        purpose: "Purpose",
        in_request_mode: "In Request Mode",
        accepted: "Accepted"
      )
    ])
  end

  it "renders a list of api_keys" do
    render
    assert_select "tr>td", text: "Key Val".to_s, count: 2
    assert_select "tr>td", text: "U".to_s, count: 2
    assert_select "tr>td", text: "Purpose".to_s, count: 2
    assert_select "tr>td", text: "In Request Mode".to_s, count: 2
    assert_select "tr>td", text: "Accepted".to_s, count: 2
  end
end
