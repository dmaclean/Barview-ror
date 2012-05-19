#################################################################################
# We only use POST and DELETE for this controller.  There is currently no need
# for us to create, update, or show a bar event via the HTML forms.
#
# Therefore, any non POST or DELETE will be redirected back to the home page.
#################################################################################
class BarEventsController < ApplicationController
  # GET /bar_events
  # GET /bar_events.json
  def index
    # We've got a good mobile user.  Fetch their deals/events
    if @valid_mobile_token
      xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><events>"
      
      events = BarEvent.get_events_for_favorites(request.env["HTTP_USER_ID"])
      for e in events do
        xml += "<event><bar>#{ e.name }</bar><detail>#{ e.detail }</detail></event>"
      end
      
      xml += "</events>"
      
      render :text => xml
      return
      
    # Browser-based request, redirect back to home page.
    else
      redirect_to_home
    end
  end

  # GET /bar_events/1
  # GET /bar_events/1.json
  def show
    redirect_to_home
    
    #@bar_event = BarEvent.find(params[:id])

    #respond_to do |format|
    #  format.html # show.html.erb
    #  format.json { render :json => @bar_event }
    #end
  end

  # GET /bar_events/new
  # GET /bar_events/new.json
  def new
    redirect_to_home
    
    #@bar_event = BarEvent.new

    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.json { render :json => @bar_event }
    #end
  end

  # GET /bar_events/1/edit
  def edit
    redirect_to_home
    
    #@bar_event = BarEvent.find(params[:id])
  end

  # POST /bar_events
  # POST /bar_events.json
  def create
    @bar_event = BarEvent.new
    @bar_event.bar_id = params[:bar_id]
    @bar_event.detail = params[:detail]
    
    #for header in request.env.select {|k,v| k.match("^HTTP.*")}
    #  print header
    #end
    #print "Bar id: " + request.env["HTTP_BAR_ID"] + "\n"
    #print "Session id: " + request.env["HTTP_SESSION_ID"] + "\n"
    #print "Bar name: " + request.env["HTTP_BAR_NAME"] + "\n"
    #print "CSRF token: " + request.env["HTTP_X_CSRF_TOKEN"] + "\n"
    
    # Get data and save to the bar_event object
    #print params.to_s

    respond_to do |format|
      if @bar_event.save
        #format.html { redirect_to @bar_event, :notice => 'Bar event was successfully created.' }
        format.html { render :text => @bar_event.id }
        format.json { render :json => @bar_event, :status => :created, :location => @bar_event }
      else
        format.html { render :action => "new" }
        format.json { render :json => @bar_event.errors, :status => :unprocessable_entity }
      end
	end
  end

  # PUT /bar_events/1
  # PUT /bar_events/1.json
  def update
    redirect_to_home
    
    #@bar_event = BarEvent.find(params[:id])

    #respond_to do |format|
    #  if @bar_event.update_attributes(params[:bar_event])
    #    format.html { redirect_to @bar_event, :notice => 'Bar event was successfully updated.' }
    #    format.json { head :no_content }
    #  else
    #    format.html { render :action => "edit" }
    #    format.json { render :json => @bar_event.errors, :status => :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /bar_events/1
  # DELETE /bar_events/1.json
  def destroy
    @bar_event = BarEvent.find(params[:id])
    @bar_event.destroy

    respond_to do |format|
      #format.html { redirect_to bar_events_url }
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end
end
