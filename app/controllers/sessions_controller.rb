class SessionsController < ApplicationController
  skip_before_action :require_login
  
  # def new
  # end

  # def create 
  # end

  def destroy
    session.delete :user_id
    user = nil
    redirect_to root_path
  end

  def omniauth
    data = request.env['omniauth.auth']

    user = User.find_by(uid: data[:uid], provider: data[:provider])
    if(!user)
      user = User.create do |u|
        u.uid =  data[:uid]
        u.provider = data[:provider]
        u.username = data[:info][:name]
        u.firstname = data[:info][:first_name]
        u.email = data[:info][:email]
        u.photo = data[:info][:image]
      end
      user.directories.create(name: "root", parent_id: nil)
    end

    if user.valid?
      #log them in
      session[:user_id] = user.id 
      session[:directory] = Directory.where(user_id: user.id, name: "root")[0].id
      redirect_to logged_in_path
    else
      redirect_to root_path 
    end
     
  end
end
