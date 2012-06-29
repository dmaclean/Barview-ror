require 'test_helper'

class BarhomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "bar is not logged in" do
    get :index
    assert_select '#welcome h1', 'Welcome to Bar-view.com!'
	assert_select '#intro_desc', :minimum => 1
	assert_select '#post_deals', :minimum => 1
	assert_select '#webcam_desc', :minimum => 1
	assert_select '#signup_desc', :minimum => 1
  end
  
  test "bar is logged in" do
    session[:bar_id] = 1
    get :index
    assert_select '#realtime', :minimum => 1
    assert_select '#broadcast', :minimum => 1
    assert_select '#bar_events_list', :minimum => 1
    assert_select '.bar_events_edit', :minimum => 1
  end
end
