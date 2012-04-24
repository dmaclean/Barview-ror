class UserLoginController < ApplicationController
  def new
    if session[:user_id] != nil
      redirect_to userhome_url
    end
  end

  def create
    if user = User.authenticate(params[:email], params[:password])
      session[:user_id] = user.id
      session[:usertype] = "BARVIEW"
      redirect_to userhome_url
    else
      redirect_to userhome_url, :flash => { :error => "Invalid username/password combination" }  
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to userhome_url, :flash => { :notice => "Logged out" }
  end
end
