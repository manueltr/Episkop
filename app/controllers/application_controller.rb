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
    end

    def account
    end

end
