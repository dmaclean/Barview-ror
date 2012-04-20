class BarloginController < ApplicationController
  def new
    if session[:bar_id] != nil
      redirect_to barhome_url
    end
  end

  def create
    if bar = Bar.authenticate(params[:name], params[:password])
      session[:bar_id] = bar.id
      redirect_to barhome_url
    else
      redirect_to barhome_url, :flash => { :error => "Invalid username/password combination" }
    end
  end

  def destroy
    session[:bar_id] = nil
    redirect_to barhome_url, :notice => "Logged out"
  end
end
