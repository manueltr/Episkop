class ApplicationController < ActionController::Base
    # CSRF error
    protect_from_forgery with: :null_session
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

      #check for api key
      api_key = request.headers["ApiKey"]
      if session[:user_id]
        user_id = session[:user_id] 
      elsif api_key
        user_id = ApiKey.where(api_token: api_key)[0].user_id
      else
        user_id = nil
      end

      if user_id == nil && api_key == nil
        session[:store_location] = request.fullpath
        redirect_to "/auth/google_oauth2"
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

    def directory_back
      @user = User.find(session[:user_id])

      @directory = @user.directories.where(id: session[:directory])[0]
      @directory = @directory.parent

      if @directory == nil
        @directory = @user.directories.where(name: "root")[0]
      end

      @children = @directory.children
      @polls = @directory.polls 

      session[:directory] = @directory.id

      respond_to do |format|
        format.js {render 'application/directory'}
      end

    end


    def settings
      @user = User.find(session[:user_id])
      @profile_picture = @user.photo
      @name = @user.username
      @settings = true

      @api_keys = @user.api_keys
      @requested_api_keys = ApiKey.where(in_req_mode: true)
      render layout: "poll"
      # render "settings"
    end

end
