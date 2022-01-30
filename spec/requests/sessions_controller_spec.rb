require 'rails_helper'

RSpec.describe "SessionsControllers", type: :request do
  
    it "should logout and redirect the user when getting #destryo" do
        get '/logout'
        expect(response).to redirect_to(root_path)
        expect(session[:user_id]).to eq(nil) 
    end

    it "should set the user and redirect to the homepage" do
        request.env['omniauth.auth'] = {:uid => "test", :povider => "google"}
        get '/login'
        expect(session[:user_id]).to eq(User.find_by(:username => "testUser1").id)
        expect(response).to redirect_to(logged_in_path)
    end
end
