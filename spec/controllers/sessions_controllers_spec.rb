RSpec.describe "SessionsControllers", type: :controller do

    before (:each) do
        @controller = SessionsController.new
    end

    it "should sign in the user" do 
        request.env['omniauth.auth'] = {uid: "test", provider: "google"}
        get :omniauth, params: {:provider => 'google'}
        expect(session[:user_id]).to eq(User.find_by(:username => "testUser1").id)
        expect(response).to redirect_to(logged_in_path)
    end

    it "should create a new user if it doesnt exit and redirect to logged in path" do
        request.env['omniauth.auth'] = {uid: "testing123", 
                                        provider: "google",
                                        info: { name: "testUser4", first_name: "",
                                                email: "", image: ""}}
        get :omniauth, params: {:provider => 'google'}
        expect(session[:user_id]).to eq(User.find_by(:username => "testUser4").id)
        expect(response).to redirect_to(logged_in_path)
        User.destroy(User.find_by(:username => "testUser4").id)
    end
end