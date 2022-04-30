require 'rails_helper'

RSpec.describe "SessionsControllers", type: :request do
  
    it "should logout and redirect the user when getting #destroyed" do
        get '/logout'
        expect(response).to redirect_to(root_path)
        expect(session[:user_id]).to eq(nil) 
    end
end
