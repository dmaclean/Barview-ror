require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    
    @new = {
      :id => 100,
      :first_name => "Dan",
      :last_name => "MacLean",
      :dob => "1982-10-21",
      :gender => "Male",
      :email => "dan@bar-view.com",
      :city => "Medfield",
      :state => "MA",
      :password => "password",
      :password_confirmation => "password"
    }
    
    @update = {
      :first_name => "Dan",
      :last_name => "MacLean",
      :dob => "1982-10-21",
      :gender => "Male",
      :email => "dmaclean82@gmail.com",
      :city => "Medfield",
      :state => "MA",
    }
  end

  test "non-admin cannot see user list" do
    get :index
    assert_redirected_to '/'
  end

  test "should get index" do
    session[:admin_id] = 1
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_match /Sign up!/, response.body
    assert_match /I have read and agree to the/, response.body
    assert_select '#password_explanation', 0
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      #post :create, :user => { :city => @user.city, :dob => @user.dob, :email => @user.email, :first_name => @user.first_name, :gender => @user.gender, :hashed_password => @user.hashed_password, :last_name => @user.last_name, :state => @user.state }
      post :create, :user => @new
    end

    assert_redirected_to '/userhome'
  end

  test "should show user" do
    get :show, :id => @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user
    assert_match /Update info/, response.body
    assert_no_match /I have read and agree to the/, response.body
    assert_select '#password_explanation', 1
    assert_response :success
  end

  test "should update user" do
    #put :update, :id => @user, :user => { :city => @user.city, :dob => @user.dob, :email => @user.email, :first_name => @user.first_name, :gender => @user.gender, :hashed_password => @user.hashed_password, :last_name => @user.last_name, :state => @user.state }
    put :update, :id => @user, :user => @update
    assert_redirected_to '/'#user_path(assigns(:user))
  end

  test "non-admin cannot destroy user" do
    assert_difference('User.count', 0) do
      delete :destroy, :id => @user
    end
    
    assert_redirected_to '/'
  end

  test "should destroy user" do
    session[:admin_id] = 1
    
    favecount = Favorite.count
    qcount = UserQuestionnaireAnswer.count
    tokencount = MobileToken.count
    fbusercount = FbUser.count
  
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user
    end
    
    favecount2 = Favorite.count
    qcount2 = UserQuestionnaireAnswer.count
    tokencount2 = MobileToken.count
    fbusercount2 = FbUser.count
    
    assert favecount > favecount2
    assert qcount > qcount2
    assert tokencount > tokencount2
    assert fbusercount > fbusercount2

    assert_redirected_to users_path
  end
  
  test "Show and Back links are gone" do
    get :edit, :id => 1
    assert_no_match /Show/, response.body
    assert_no_match /Back/, response.body
  end
end
