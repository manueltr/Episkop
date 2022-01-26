class ApplicationController < ActionController::Base
    before_action :require_login, except: [:welcome]
    

    private
    def require_login
      user = session[:user_id]
      if user == nil
        flash[:alert] = "You must be logged in to access this section"
        redirect_to root_path
      end
    end

    public

    def welcome
        if session[:user_id]
            redirect_to logged_in_path
        else
            render "welcome"
        end
    end

    def account
      user = User.find(session[:user_id])
      @profile_picture = user.photo
      @name = user.username

      render layout: "poll"
    end

end
