class ApplicationController < ActionController::Base

    # set session value for request/controller testing
    if Rails.env.test?
      prepend_before_action :stub_current_user
      def stub_current_user
        if !params[:user]
          session[:user_id] = 1
        end
      end
    end
    # !DELETE

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
      @user = User.find(session[:user_id])
      @profile_picture = @user.photo
      @name = @user.username

      #set user polls
      @polls = @user.polls.where(directory_id: session[:directory])
      render layout: "poll"
    end

    def directory
      @user = User.find(session[:user_id])
      @polls = @user.polls.where(directory_id: session[:directory])
      respond_to do |format|
        format.js
      end
    end

end
