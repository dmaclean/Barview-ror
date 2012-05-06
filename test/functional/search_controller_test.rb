require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, :search => 'MyString'
    assert_response :success
    assert_select '.row', :minimum => 3
    assert_select '.user_login', :minimum => 1
    assert_select '#1_favorite', 0
    assert_select '#2_favorite', 0
  end
  
  test "should get index logged in" do
    session[:user_id] = 1
    get :index, :search => 'MyString'
    assert_response :success
    assert_select '.row', :minimum => 3
    assert_select '.user_login', 0
    assert_select '#1_favorite', 'Remove from favorites'
    assert_select '#2_favorite', 'Add to favorites'
  end
  
  test "do not find unverified bar for logged-in user" do
    session[:user_id] = 1
    get :index, :search => 'Unverified'
    assert_response :success
    assert_no_match /unverified bar/i, response.body
  end
  
  test "should get no results" do
    get :index, :search => 'doesnotexist'
    assert_response :success
    assert_select '#no_results', 'No results found.'
  end

end
