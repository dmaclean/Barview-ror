require 'test_helper'

class UserQuestionnaireControllerTest < ActionController::TestCase
  test "should get index" do
    session[:user_id] = 1
    get :index
    assert_response :success
  end
  
  test "user not logged in" do
    get :index
    assert_redirected_to '/userhome'
  end

  test "new user answers" do
    session[:user_id ] = 1
    post :create
    assert_redirected_to '/userhome'
  end

end
