require 'net/http'

class BarsController < ApplicationController
  # GET /bars
  # GET /bars.json
  def index
    # If request comes from a non-admin then boot them to the main page
    unless session[:admin_id]
      redirect_to_home
      return
    end
  
    # Verify a bar if one was specified
    if params[:verify]
      bar_to_verify = Bar.find(params[:verify])
      bar_to_verify.verified = 1
      unless bar_to_verify.save
        flash[:error] = "Unable to verify #{ bar_to_verify.name }"
      else
        flash[:notice] = "Successfully verified #{ bar_to_verify.name }"
        BvMailer.bar_verification_email(bar_to_verify).deliver
      end
    end
    
    @bars = Bar.order(:verified)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @bars }
    end
  end

  # GET /bars/1
  # GET /bars/1.json
  def show
    # Let's make sure someone is logged in.  If not, send them to the user homepage
    if not session[:user_id] and not session[:bar_id]
      redirect_to '/userhome'
      return
    end
  
    # Fetch the bar being requested
    begin
      @bar = Bar.find(params[:id])
    rescue
      flash[:notice] = 'The requested bar does not exist.'
      redirect_to '/userhome'
      return
    end
    
    # Fetch the favorites 
    @favorite = Favorite.where('user_id = ? and bar_id = ?', session[:user_id], @bar.id)
    
    # Fetch the events
    @events = BarEvent.where('bar_id = ?', @bar.id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @bar }
    end
  end

  # GET /bars/new
  # GET /bars/new.json
  def new
    @bar = Bar.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @bar }
    end
  end

  # GET /bars/1/edit
  def edit
    @bar = Bar.find(params[:id])
  end

  # POST /bars
  # POST /bars.json
  def create
    @bar = Bar.new
    @bar.address = params[:bar][:address]
    @bar.city = params[:bar][:city]
    @bar.email = params[:bar][:email]
    @bar.name = params[:bar][:name]
    @bar.reference = params[:bar][:reference]
    @bar.state = params[:bar][:state]
    @bar.username = params[:bar][:username]
    @bar.password = params[:bar][:password]
    @bar.verified = 0
    @bar.zip = params[:bar][:zip]
    
    @bar.fetch_coordinates

    respond_to do |format|
      if @bar.save
        BvMailer.bar_registration_email(@bar).deliver
        BvMailer.support_alert_email(@bar).deliver
      
        format.html { redirect_to bars_url, :notice => "Bar #{@bar.name} was successfully created." }
        format.json { render :json => @bar, :status => :created, :location => @bar }
      else
        format.html { render :action => "new" }
        format.json { render :json => @bar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bars/1
  # PUT /bars/1.json
  def update
    @bar = Bar.find(params[:id])
    @bar.password = params[:bar][:password]
    submission_hash = {
      :address => params[:bar][:address],
      :city => params[:bar][:city],
      :email => params[:bar][:email],
      :name => params[:bar][:name],
      :state => params[:bar][:state],
      :zip => params[:bar][:zip]
    }

    respond_to do |format|
      if @bar.update_attributes(submission_hash)
        @bar.fetch_coordinates
        @bar.save
        
        format.html { redirect_to bars_url, :notice => "#{@bar.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @bar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bars/1
  # DELETE /bars/1.json
  def destroy
    # Make sure the request came from an admin
    unless session[:admin_id]
      redirect_to_home
      return
    end
  
    @bar = Bar.find(params[:id])
    @bar.destroy

    respond_to do |format|
      format.html { redirect_to bars_url }
      format.json { head :no_content }
    end
  end
end
