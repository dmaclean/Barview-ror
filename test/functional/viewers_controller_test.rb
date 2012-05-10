require 'test_helper'

class ViewersControllerTest < ActionController::TestCase
  test "found viewers" do
    # Create a new bar image request
    bir = BarImageRequest.new
    bir.bar_id = 1
    bir.user_id = 1
    bir.save
    
    request.env['SECONDS_BACK'] = 5
    session[:bar_id] = 1
    get :index
    assert_response :success
    assert response.body != ''
  end
  
  test "no viewers available" do
    request.env['SECONDS_BACK'] = 1
    session[:bar_id] = 2
    get :index
    assert_response :success
    assert response.body == ''
  end
  
  test "bar not logged in" do
    request.env['SECONDS_BACK'] = 1
    get :index
    assert_response :success
    assert response.body == 'Invalid bar id'
  end

end
