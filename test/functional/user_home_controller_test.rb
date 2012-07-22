require 'test_helper'

class UserHomeControllerTest < ActionController::TestCase
  test "should get index user with favorites" do
    session[:user_id ] = 1
    get :index
    assert_select '#fave_h1', 'Your Favorites'
    assert_select '#feeds_h1', 'Feeds from your favorites'
    assert_select '#fave_col' do |cols|
      assert_select 'ul' do 
        assert_select 'li', 2
      end
    end
    assert_response :success
  end
  
  test "Issue 24 - Nonfavorites images loading with image of last favorite bar." do
    session[:user_id] = 1
    get :index
    assert_match /2\.jpeg/i, response.body
    
    assert_response :success
  end
  
  test "make sure unverified bar does not show up for logged-in user" do
    session[:user_id] = 1
    get :index
    assert_no_match /Unverified Bar/i, response.body
    assert_no_match /Unverified event/i, response.body
  end
  
  test "make sure unverified bar does not show up for logged-out user" do
    get :index
    assert_no_match /Unverified Bar/i, response.body
    assert_no_match /Unverified event/i, response.body
  end
  
  test "should get index user without favorites" do
    session[:user_id ] = 3
    get :index
    assert_select '#fave_h1', 'Bar-view Bars'
    assert_select '#feeds_h1', 'Current Feeds'
    assert_response :success
  end
  
  test "bar user is lost" do
    session[:bar_id] = 1
    get :index
    assert_redirected_to barhome_url
  end
  
  test "show questionnaire" do
    session[:user_id] = 2
    get :index
    
    assert_response :success
    assert_select '#show_questionnaire', 'true'
    assert_select '#q1_0', 1
    assert_select '#q2_0', 1
  end
  
  test "do not show questionnaire" do
    session[:user_id] = 1
    get :index
    
    assert_response :success
    assert_select '#show_questionnaire', 'false'
  end

end
