require 'rails_helper'

RSpec.describe "api_keys/new", type: :view do
  before(:each) do
    assign(:api_key, ApiKey.new(
      key_val: "MyString",
      u_id: "MyString",
      purpose: "MyString",
      in_request_mode: "MyString",
      accepted: "MyString"
    ))
  end

  it "renders new api_key form" do
    render

    assert_select "form[action=?][method=?]", api_keys_path, "post" do

      assert_select "input[name=?]", "api_key[key_val]"

      assert_select "input[name=?]", "api_key[u_id]"

      assert_select "input[name=?]", "api_key[purpose]"

      assert_select "input[name=?]", "api_key[in_request_mode]"

      assert_select "input[name=?]", "api_key[accepted]"
    end
  end
end
