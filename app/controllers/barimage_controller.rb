require 'base64'

class BarimageController < ApplicationController
  def show
    @img = get_barimage_object
    
    respond_to do |format|
      format.html { render :text => Base64.encode64(open('public/' + @img.image, 'r').read) }
      format.json { render :json => @img }
      format.xml { render :text => render_bv_xml(@img) }
      format.jpeg { send_data(open('public/' + @img.image, 'r').read, :type => 'image/jpg', :disposition => 'inline') }
    end
  end
  
  def update
    data = request.body.read
    if data.size > 0
      @img = Barimage.find_by_bar_id(params[:id])
      @img.write_file(data)
    end

    respond_to do |format|
      format.html { render :text => 'OK' }
    end
  end
  
  private
  def render_bv_xml(img)
    xml = '<?xml version="1.0" encoding="UTF-8" ?><barimage><bar_id>' + img.bar_id.to_s + '</bar_id>'
    xml += '<image>' + Base64.encode64(open('public/' + @img.image, 'r').read) + '</image></barimage>'
    
    xml
  end
  
  def get_barimage_object
    begin
      @img = Barimage.find_by_bar_id!(params[:id])
      
      
    rescue
      @img = Barimage.new
      @img.bar_id = -1
      @img.image = 'broadcast_images/barview.jpg'
    end
    
    @img
  end
end
