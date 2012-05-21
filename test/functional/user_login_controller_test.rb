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
    assert_equal "BARVIEW", session[:usertype]
  end
  
  test "should fail login" do
    user = users(:one)
    post :create, :email => user.email, :password => 'something else'
    assert_redirected_to userhome_url
    assert_equal flash[:error], 'Invalid username/password combination'
    assert_equal session[:user_id], nil
  end

  test "should logout" do
    session[:user_id] = 1
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
  
  test "mobile login success" do
    user = users(:one)
    request.env['HTTP_IS_MOBILE'] = "true"
    request.env['HTTP_BV_USERNAME'] = user.email
    request.env['HTTP_BV_PASSWORD'] = 'secret'
    user = users(:one)
    post :create
    assert_response :success
    assert user.id == session[:user_id]
    assert response.body =~ /<user><id>1<\/id>\S+<\/user>/i
  end
  
  test "mobile login failure" do
    request.env['HTTP_IS_MOBILE'] = "true"
    user = users(:one)
    post :create, :email => user.email, :password => 'badpass'
    assert_response :success
    assert response.body == "<user></user>"
  end
  
  test "mobile logout" do
    session[:user_id] = 1
    request.env['HTTP_BV_TOKEN'] = "token1"
    
    assert_difference("MobileToken.count", -1) do
      delete :destroy
    end
    assert_equal session[:user_id], nil
    assert_response :success
  end
end
