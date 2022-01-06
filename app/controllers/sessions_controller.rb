class SessionsController < ApplicationController
  skip_before_action :require_login
  
  def new
  end

  def create 
  end

  def destroy
    session.delete :user_id
  end

  def omniauth
    
    data = request.env['omniauth.auth']
    user = User.find_or_create_by(uid: data[:uid], provider: data[:provider]) do |u|
      u.username = data[:info][:name]
      u.firstname = data[:info][:first_name]
      u.email = data[:info][:email]
      u.photo = data[:info][:image]
    end

    if user.valid?
      #log them in
      session[:user_id] = user.id 
      redirect_to logged_in_path
    else
      redirect_to root_path 
    end
     
  end
end
