require 'test_helper'

class BarEventsControllerTest < ActionController::TestCase
  setup do
    @bar_event = bar_events(:one)
  end

  test "should get index for browser user" do
    get :index
    
    assert_redirected_to '/'
  end
  
  test "should get index for mobile user" do
    session[:user_id] = 1
    get :index
    
    assert_response :success
    assert response.body == "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><events><event><bar>MyString</bar><detail>MyText</detail></event></events>"
  end
  
  test "should get index - no USER_ID" do
    get :index
    
    assert_redirected_to '/'
  end
  
  #test "should get index - no BV_TOKEN header" do
  #  request.env["HTTP_USER_ID"] = "dmaclean@agencyport.com"
  #  
  #  get :index
  #  
  #  assert_redirected_to '/'
  #end

  test "should get new" do
    get :new
    #assert_response :success
    assert_redirected_to '/'
  end

  test "should create bar_event" do
    
    assert_difference('BarEvent.count') do
      post :create, :bar_event => { :bar_id => @bar_event.bar_id, :detail => @bar_event.detail }
    end

    assert_response :success
    assert_not_nil response.body =~ /\d+/	# Make sure we are getting back a number
  end

  test "should show bar_event" do
    get :show, :id => @bar_event
    #assert_response :success
    assert_redirected_to '/'
  end

  test "should get edit" do
    get :edit, :id => @bar_event
    #assert_response :success
    assert_redirected_to '/'
  end

  test "should update bar_event" do
    put :update, :id => @bar_event, :bar_event => { :bar_id => @bar_event.bar_id, :detail => @bar_event.detail }
    assert_redirected_to '/'
  end

  test "should destroy bar_event" do
    assert_difference('BarEvent.count', -1) do
      delete :destroy, :id => @bar_event
    end

    assert_response :success
  end
end
