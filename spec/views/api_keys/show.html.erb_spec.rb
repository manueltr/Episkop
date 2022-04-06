require 'rails_helper'

RSpec.describe "api_keys/show", type: :view do
  before(:each) do
    @api_key = assign(:api_key, ApiKey.create!(
      key_val: "Key Val",
      u_id: "U",
      purpose: "Purpose",
      in_request_mode: "In Request Mode",
      accepted: "Accepted"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Key Val/)
    expect(rendered).to match(/U/)
    expect(rendered).to match(/Purpose/)
    expect(rendered).to match(/In Request Mode/)
    expect(rendered).to match(/Accepted/)
  end
end
