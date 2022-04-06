require 'rails_helper'

RSpec.describe "api_keys/edit", type: :view do
  before(:each) do
    @api_key = assign(:api_key, ApiKey.create!(
      key_val: "MyString",
      u_id: "MyString",
      purpose: "MyString",
      in_request_mode: "MyString",
      accepted: "MyString"
    ))
  end

  it "renders the edit api_key form" do
    render

    assert_select "form[action=?][method=?]", api_key_path(@api_key), "post" do

      assert_select "input[name=?]", "api_key[key_val]"

      assert_select "input[name=?]", "api_key[u_id]"

      assert_select "input[name=?]", "api_key[purpose]"

      assert_select "input[name=?]", "api_key[in_request_mode]"

      assert_select "input[name=?]", "api_key[accepted]"
    end
  end
end
