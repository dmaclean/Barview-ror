require 'test_helper'

class FavoritesControllerTest < ActionController::TestCase
  setup do
    @favorite = favorites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:favorites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favorite" do
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
    assert_difference('Favorite.count', -1) do
      delete :destroy, :id => @favorite
    end

    assert_redirected_to favorites_path
  end
end
