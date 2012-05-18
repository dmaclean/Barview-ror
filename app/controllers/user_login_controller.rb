class UserLoginController < ApplicationController
  def new
    if session[:user_id] != nil
      redirect_to userhome_url
    end
  end

  def create
    # Check if the user is mobile
    if request.env["HTTP_IS_MOBILE"] == "true"
      email = request.env["HTTP_BV_USERNAME"]
      password = request.env["HTTP_BV_PASSWORD"]
    else
      email = params[:email]
      password = params[:password]
    end
  
    if user = User.authenticate(email, password)
      session[:user_id] = user.id
      session[:usertype] = "BARVIEW"
      
      if request.env["HTTP_IS_MOBILE"] == "true"
        render :text => User.mobile_login(email, password)
      else
        redirect_to userhome_url
      end

    else
      if request.env["HTTP_IS_MOBILE"] == "true"
        render :text => User.mobile_login(email, password)
      else
        redirect_to userhome_url, :flash => { :error => "Invalid username/password combination" }  
      end
    end
  end

  def destroy
    # If there is a token then we have a mobile logout.
    if request.env["HTTP_BV_TOKEN"]
      User.mobile_logout(request.env["HTTP_BV_TOKEN"])
    else
      session[:user_id] = nil
      redirect_to userhome_url, :flash => { :notice => "Logged out" }
    end
  end
end
