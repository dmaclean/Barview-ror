require 'test_helper'

class AdminsControllerTest < ActionController::TestCase
  setup do
    @admin = admins(:one)
  end

  #test "should get index" do
  #  get :index
  #  assert_response :success
  #  assert_not_nil assigns(:admins)
  #end

  #test "should get new" do
  #  get :new
  #  assert_response :success
  #end

  test "successful login" do
    post :create, :name => 'admin', :password => 'getatme'
    assert_not_nil session[:admin_id]
    assert_redirected_to '/bars'
    
    #assert_difference('Admin.count') do
    #  post :create, :admin => { :hashed_password => @admin.hashed_password, :name => @admin.name, :salt => @admin.salt }
    #end

    #assert_redirected_to admin_path(assigns(:admin))
  end
  
  test "bad login" do
    post :create, :name => 'admin', :password => 'wrongpw'
    assert_nil session[:admin_id]
    assert_redirected_to '/'
  end

  #test "should show admin" do
  #  get :show, :id => @admin
  #  assert_response :success
  #end

  #test "should get edit" do
  #  get :edit, :id => @admin
  #  assert_response :success
  #end

  #test "should update admin" do
  #  put :update, :id => @admin, :admin => { :hashed_password => @admin.hashed_password, :name => @admin.name, :salt => @admin.salt }
  #  assert_redirected_to admin_path(assigns(:admin))
  #end

  test "should destroy admin" do
    session[:admin_id] = 1
    delete :destroy
    assert_nil session[:admin_id]
    assert_redirected_to '/'
    
    #assert_difference('Admin.count', -1) do
    #  delete :destroy, :id => @admin
    #end

    #assert_redirected_to admins_path
  end
end
