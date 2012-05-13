require 'test_helper'

class ForgotPasswordControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "do not reset password for bad email" do
    post :create, :email => 'baduser@fake.com'
    assert_redirected_to '/'
    assert flash[:error] == 'You have specified an invalid email address.'
  end
  
  test "reset password for valid email" do
    post :create, :email => 'dmaclean@agencyport.com'
    assert_redirected_to '/'
    assert flash[:notice] == 'Your password has been reset.  You should receive an email soon with your new temporary password.'
  end

end
