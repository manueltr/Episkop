require 'rails_helper'

RSpec.describe "api_keys/edit", type: :view do
  before(:each) do
    @api_key = assign(:api_key, ApiKey.create!(
      purpose: "MyString",
      in_req_mode: "MyString",
      accepted: "MyString",
      explanation: "MyString"
    ))
  end

  it "renders the edit api_key form" do
    render

    assert_select "form[action=?][method=?]", api_key_path(@api_key), "post" do

      assert_select "input[name=?]", "api_key[purpose]"

      assert_select "input[name=?]", "api_key[in_req_mode]"

      assert_select "input[name=?]", "api_key[accepted]"

      assert_select "input[name=?]", "api_key[explanation]"
    end
  end
end
