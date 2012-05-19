class FavoritesController < ApplicationController
  # GET /favorites
  # GET /favorites.json
  def index
    # Make sure the request comes from a valid user_id/token pairing.
    if not @valid_mobile_token
      render :text => "<error>No token provided.</error>"
      return
    end
    
    render :text => Favorite.generate_xml_for_favorites(request.env["HTTP_USER_ID"])
  end

  # GET /favorites/1
  # GET /favorites/1.json
  def show
    @favorite = Favorite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @favorite }
    end
  end

  # GET /favorites/new
  # GET /favorites/new.json
  def new
    @favorite = Favorite.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @favorite }
    end
  end

  # GET /favorites/1/edit
  def edit
    @favorite = Favorite.find(params[:id])
  end

  # POST /favorites
  # POST /favorites.json
  def create
    @favorite = Favorite.new
    @favorite.user_id = request.env['HTTP_USER_ID']
    @favorite.bar_id = request.env['HTTP_BAR_ID']

    respond_to do |format|
      if @favorite.save
        #format.html { redirect_to @favorite, :notice => 'Favorite was successfully created.' }
        format.html { render :text => @favorite.id }
        format.json { render :json => @favorite, :status => :created, :location => @favorite }
      else
        format.html { render :action => "new" }
        format.json { render :json => @favorite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /favorites/1
  # PUT /favorites/1.json
  def update
    @favorite = Favorite.find(params[:id])

    respond_to do |format|
      if @favorite.update_attributes(params[:favorite])
        format.html { redirect_to @favorite, :notice => 'Favorite was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @favorite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /favorites/1
  # DELETE /favorites/1.json
  def destroy
    # Make sure the user is deleting their own favorite
    if session[:user_id].to_s != request.env['HTTP_USER_ID']
      logger.debug { 'The user id (' + session[:user_id].to_s + ') in session does not match the one in the request header (' + request.env['HTTP_USER_ID'] + ').' }
      respond_to do |format|
        format.html { render :text => '500' }
        format.json { head :no_content }
      end
      
      return
    end
  
    begin
      Favorite.delete_all(['user_id = ? and bar_id = ?', request.env['HTTP_USER_ID'], request.env['HTTP_BAR_ID']])
    rescue => ex
      print "Unable to delete favorite with user_id #{ request.env['HTTP_USER_ID'] } and bar_id #{ request.env['HTTP_BAR_ID'] }.  #{ex.class} - #{ex.message}"
      respond_to do |format|
        format.html { render :text => '500' }
        format.json { head :no_content }
      end
      
      return
    end

    respond_to do |format|
      format.html { render :text => '200' }
      format.json { head :no_content }
    end
  end
end
