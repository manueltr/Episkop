require 'rails_helper'

RSpec.describe "api_keys/new", type: :view do
  before(:each) do
    assign(:api_key, ApiKey.new(
      purpose: "MyString",
      in_req_mode: "MyString",
      accepted: "MyString",
      explanation: "MyString"
    ))
  end

  it "renders new api_key form" do
    render

    assert_select "form[action=?][method=?]", api_keys_path, "post" do

      assert_select "input[name=?]", "api_key[purpose]"

      assert_select "input[name=?]", "api_key[in_req_mode]"

      assert_select "input[name=?]", "api_key[accepted]"

      assert_select "input[name=?]", "api_key[explanation]"
    end
  end
end
