require 'test_helper'

class FavoritesControllerTest < ActionController::TestCase
  setup do
    @favorite = favorites(:one)
  end

  test "should get index for mobile user" do
    request.env['HTTP_USER_ID'] = "dmaclean@agencyport.com"
    request.env['HTTP_BV_TOKEN'] = 'token1'
    get :index
    assert_response :success
    assert response.body =~ /<favorites><favorite><bar_id>1<\/bar_id><address>MyString<\/address><name>MyString<\/name><\/favorite><\/favorites>/i
  end
  
  test "should get index for mobile user without token" do
    request.env['HTTP_USER_ID'] = "dmaclean@agencyport.com"
    get :index
    assert response.body =~ /<error>No token provided.<\/error>/i
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favorite - browser" do
    session[:user_id] = 1
    @request.env['USER_ID'] = 1
    @request.env['BAR_ID'] = 2
  
    assert_difference('Favorite.count') do
      #post :create, :favorite => { :bar_id => @favorite.bar_id, :user_id => @favorite.user_id }
      post :create
    end

    #assert_redirected_to favorite_path(assigns(:favorite))
    assert_response :success
    assert_not_nil response.body =~ /\d+/	# Make sure we are getting back a number
  end
  
  test "should create favorite - mobile" do
    @request.env['HTTP_USER_ID'] = "dmaclean@agencyport.com"
    @request.env['HTTP_BAR_ID'] = 2
    @request.env['HTTP_BV_TOKEN'] = "token1"
    
    assert_difference('Favorite.count', 1) do
      post :create
    end
    
    assert_response :success
    assert_not_nil response.body =~ /\d+/	# Make sure we are getting back a number
  end
  
  test "should create favorite - fail with no session or token" do
    @request.env['USER_ID'] = 1
    @request.env['BAR_ID'] = 2
    
    assert_difference('Favorite.count', 0) do
      post :create
    end
    
    assert_response :success
    assert_not_nil response.body == "Error occurred."
  end

  test "should show favorite" do
    get :show, :id => @favorite
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @favorite
    assert_response :success
  end

  test "should update favorite" do
    put :update, :id => @favorite, :favorite => { :bar_id => @favorite.bar_id, :user_id => @favorite.user_id }
    assert_redirected_to favorite_path(assigns(:favorite))
  end

  test "should destroy favorite" do
    session[:user_id] = 2
    @request.env['HTTP_USER_ID'] = '2'
  
    assert_difference('Favorite.count', -1) do
      delete :destroy, :id => '2'
    end

    assert_response :success
    assert response.body == '200'
  end
  
  test "should destroy favorite bad bar" do
    session[:user_id] = 1
    @request.env['HTTP_USER_ID'] = '1'
  
    assert_no_difference('Favorite.count') do
      delete :destroy, :id => '9999'
    end

    assert_response :success
    assert response.body == '200'
  end
  
  test "should destroy favorite not logged in user" do
    session[:user_id] = 2
    @request.env['HTTP_USER_ID'] = '1'
  
    assert_no_difference('Favorite.count') do
      delete :destroy, :id => '2'
    end

    assert_response :success
    assert response.body == '500'
  end
  
  test "should destroy favorite good mobile user" do
    @request.env['HTTP_BV_TOKEN'] = 'token1'
    @request.env['HTTP_USER_ID'] = 'dmaclean@agencyport.com'
    
    assert_difference('Favorite.count', -1) do
      delete :destroy, :id => '1'
    end

    assert_response :success
    assert response.body =~ /<favorites>.*<\/favorites>/i
  end
  
  test "should destroy favorite bad mobile user" do
    @request.env['HTTP_BV_TOKEN'] = 'token1'
    @request.env['HTTP_USER_ID'] = '1'
    
    assert_no_difference('Favorite.count') do
      delete :destroy, :id => '2'
    end

    assert_response :success
    assert response.body == '500'
  end
end
