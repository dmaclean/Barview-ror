require 'test_helper'

class UserLoginControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    user = users(:one)
    post :create, :email => user.email, :password => 'secret'
    assert_redirected_to userhome_url
    assert_equal user.id, session[:user_id]
  end
  
  test "should fail login" do
    user = users(:one)
    post :create, :email => user.email, :password => 'something else'
    assert_redirected_to userhome_url
    assert_equal flash[:error], 'Invalid username/password combination'
    assert_equal session[:user_id], nil
  end

  test "should logout" do
    delete :destroy
    assert_equal flash[:notice], 'Logged out'
    assert_equal session[:user_id], nil
    assert_redirected_to userhome_url
  end
  
  test "already logged in" do
    user = users(:one)
    post :create, :email => user.email, :password => 'secret'
    get :new
    assert_redirected_to userhome_url
  end
end
