require 'test_helper'

class FacebookControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    response.code == "302"
  end

  test "should get destroy browser" do
    get :destroy
    assert session['oauth'] == nil
    assert session['access_token'] == nil
    assert session[:usertype] == nil
    assert session[:user_id] == nil
    assert_redirected_to '/'
  end
  
  test "should get destroy mobile" do
    request.env['HTTP_IS_MOBILE'] = 'true'
    get :destroy
    assert session['oauth'] == nil
    assert session['access_token'] == nil
    assert session[:usertype] == nil
    assert session[:user_id] == nil
    assert_response :success
    assert response.body == "OK"
  end

end
