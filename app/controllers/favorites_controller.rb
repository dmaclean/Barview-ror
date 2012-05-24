class FavoritesController < ApplicationController
  # GET /favorites
  # GET /favorites.json
  def index
    # Make sure the request comes from a valid user_id.
    if not session[:user_id]
      logger.debug("Unable to complete request for user id #{ session[:user_id] }")
      render :text => "<error>Invalid request.</error>"
      return
    end
    
    render :text => Favorite.generate_xml_for_favorites(session[:user_id])
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
    # Make sure the user is valid.
    if not session[:user_id]
      render :text => "Error occurred."
      return
    end
  
    @favorite = Favorite.new
    @favorite.user_id = session[:user_id]
    @favorite.bar_id = request.env['HTTP_BAR_ID']

    respond_to do |format|
      if @favorite.save
        format.html { render :text => Favorite.generate_xml_for_favorites(session[:user_id]) }
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
    begin
      logger.debug("Attempting to delete favorite for user_id #{ session[:user_id] } and bar_id #{ params[:id] }")
      Favorite.delete_all(['user_id = ? and bar_id = ?', session[:user_id], params[:id]])
      logger.debug("Successfully deleted favorite for user_id #{ session[:user_id] } and bar_id #{ params[:id] }")
    rescue => ex
      logger.debug("Unable to delete favorite with user_id #{ session[:user_id] } and bar_id #{ params[:id] }.  #{ex.class} - #{ex.message}")
      respond_to do |format|
        format.html { render :text => (session[:user_id]) ? Favorite.generate_xml_for_favorites(session[:user_id]) : '500' }
        format.json { head :no_content }
      end
      
      return
    end

    respond_to do |format|
      format.html { render :text => Favorite.generate_xml_for_favorites(session[:user_id]) }
      format.json { head :no_content }
    end
  end
end
