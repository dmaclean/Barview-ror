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

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      #post :create, :user => { :city => @user.city, :dob => @user.dob, :email => @user.email, :first_name => @user.first_name, :gender => @user.gender, :hashed_password => @user.hashed_password, :last_name => @user.last_name, :state => @user.state }
      post :create, :user => @new
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, :id => @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user
    assert_response :success
  end

  test "should update user" do
    #put :update, :id => @user, :user => { :city => @user.city, :dob => @user.dob, :email => @user.email, :first_name => @user.first_name, :gender => @user.gender, :hashed_password => @user.hashed_password, :last_name => @user.last_name, :state => @user.state }
    put :update, :id => @user, :user => @update
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    favecount = Favorite.count
  
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user
    end
    
    favecount2 = Favorite.count
    assert favecount > favecount2

    assert_redirected_to users_path
  end
end
