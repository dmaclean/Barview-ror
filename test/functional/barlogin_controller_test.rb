require 'test_helper'

class BarloginControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    bar = bars(:one)
    post :create, :name => bar.username, :password => 'secret'
    assert_redirected_to barhome_url
    assert_equal bar.id, session[:bar_id]
  end
  
  test "should fail login" do
    bar = bars(:one)
    post :create, :name => bar.username, :password => 'something else'
    assert_redirected_to barhome_url
    assert_equal flash[:error], 'Invalid username/password combination'
    assert_equal session[:bar_id], nil
  end
  
  test "should fail login for unverified bar" do
    bar = bars(:unverified)
    post :create, :name => bar.username, :password => 'mypass'
    assert_redirected_to barhome_url
    assert_equal flash[:error], 'Invalid username/password combination'
    assert_equal session[:bar_id], nil
  end

  test "should logout" do
    delete :destroy
    assert_equal flash[:notice], 'Logged out'
    assert_equal session[:bar_id], nil
    assert_redirected_to barhome_url
  end
  
  test "already logged in" do
    bar = bars(:one)
    post :create, :name => bar.username, :password => 'secret'
    get :new
    assert_redirected_to barhome_url
  end

end
