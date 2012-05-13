class ForgotPasswordController < ApplicationController
  def index
  end

  def create
    user = User.find_by_email(params[:email])
    
    if user
      new_pass = user.reset_password
      
      if new_pass != nil
        redirect_to '/', :notice => 'Your password has been reset.  You should receive an email soon with your new temporary password.'
      else
        flash[:error] = 'You have specified an invalid email address.'
        redirect_to '/'
      end
    else
      flash[:error] = 'You have specified an invalid email address.'
      redirect_to '/'
    end
  end
end
