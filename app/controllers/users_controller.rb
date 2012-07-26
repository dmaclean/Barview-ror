class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    # Make sure the request came from an admin
    unless session[:admin_id]
      redirect_to_home
      return
    end
  
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @button_text = "Sign up!"
    @show_tos = true
    @show_password_explanation = false

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @button_text = "Update info"
    @show_tos = false
    @show_password_explanation = true
  end

  # POST /users
  # POST /users.json
  def create
    #@user = User.new(params[:user])
    @user = User.new
    @user.city = params[:user][:city]
    @user.dob = params[:user][:dob]
    @user.email = params[:user][:email]
    @user.first_name = params[:user][:first_name]
    @user.gender = params[:user][:gender]
    @user.last_name = params[:user][:last_name]
    @user.state = params[:user][:state]
    @user.password = params[:user][:password]

    respond_to do |format|
      if @user.save
        # Send the welcome email message
        BvMailer.user_welcome_email(@user).deliver
      
        format.html { redirect_to '/userhome', :notice => 'Your account was successfully created.  You should see an email from us soon.' }
        #format.json { render :json => @user, :status => :created, :location => @user }
      else
        @button_text = 'Sign up!'
        @show_tos = true
        @show_password_explanation = false
        format.html { render :action => "new" }
        #format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @user.password = params[:user][:password]
    
    submission_hash = {
      :city => params[:user][:city],
      :dob => params[:user][:dob],
      :first_name => params[:user][:first_name],
      :gender => params[:user][:gender],
      :last_name => params[:user][:last_name],
      :state => params[:user][:state]
    }

    respond_to do |format|
      if @user.update_attributes(submission_hash)
        format.html { redirect_to '/', :notice => "#{params[:user][:first_name]} #{params[:user][:last_name]} was successfully updated." }
        format.json { head :no_content }
      else
        @button_text = 'Update info'
        @show_tos = false
        @show_password_explanation = true
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    # Make sure the request came from an admin
    unless session[:admin_id]
      redirect_to_home
      return
    end
  
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
