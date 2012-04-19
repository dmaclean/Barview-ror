class BarEventsController < ApplicationController
  # GET /bar_events
  # GET /bar_events.json
  def index
    @bar_events = BarEvent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @bar_events }
    end
  end

  # GET /bar_events/1
  # GET /bar_events/1.json
  def show
    @bar_event = BarEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @bar_event }
    end
  end

  # GET /bar_events/new
  # GET /bar_events/new.json
  def new
    @bar_event = BarEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @bar_event }
    end
  end

  # GET /bar_events/1/edit
  def edit
    @bar_event = BarEvent.find(params[:id])
  end

  # POST /bar_events
  # POST /bar_events.json
  def create
    @bar_event = BarEvent.new(params[:bar_event])
    
    #for header in request.env.select {|k,v| k.match("^HTTP.*")}
    #  print header
    #end

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
    @bar_event = BarEvent.find(params[:id])

    respond_to do |format|
      if @bar_event.update_attributes(params[:bar_event])
        format.html { redirect_to @bar_event, :notice => 'Bar event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @bar_event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bar_events/1
  # DELETE /bar_events/1.json
  def destroy
    @bar_event = BarEvent.find(params[:id])
    @bar_event.destroy

    respond_to do |format|
      format.html { redirect_to bar_events_url }
      format.json { head :no_content }
    end
  end
end
