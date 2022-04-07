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
      user_id = session[:user_id]

      #check for api key
      api_key = request.headers["Api-Key"]

      if user_id == nil && api_key == nil
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
      @directory = @user.directories.find(session[:directory])
      @children = @directory.children
      @polls = @directory.polls
      render layout: "poll"
    end

    def directory
      @user = User.find(session[:user_id])

      @directory = @user.directories.where(name: "root")[0]
      @children = @directory.children
      @polls = @directory.polls 

      session[:directory] = @directory.id

      respond_to do |format|
        format.js
      end
    end

end
