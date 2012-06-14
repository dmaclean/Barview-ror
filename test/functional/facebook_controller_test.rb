require 'test_helper'

class FacebookControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert session['oauth'] == nil
    assert session['access_token'] == nil
    assert session[:usertype] == nil
    assert session[:user_id] == nil
    assert_redirected_to '/'
  end

end
