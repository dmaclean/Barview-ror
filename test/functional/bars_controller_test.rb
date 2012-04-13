require 'test_helper'

class BarsControllerTest < ActionController::TestCase
  setup do
    @bar = bars(:one)
    @update = {
      :id => 3,
	  :name => 'MyString',
	  :address => 'MyString',
	  :city => 'MyString',
	  :state => 'MyString',
	  :zip => '12345',
	  :lat => 1.5,
	  :lng => 1.5,
	  :username => 'MyString2',
	  :password => 'MyString',
	  :email => 'dmaclean@bar-view.com',
	  :reference => 'MyText',
	  :verified => 1
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bar" do
    assert_difference('Bar.count') do
      #post :create, :bar => { :address => @bar.address, :city => @bar.city, :email => @bar.email, :id => @bar.id, :lat => @bar.lat, :lng => @bar.lng, :name => @bar.name, :password => @bar.password, :reference => @bar.reference, :state => @bar.state, :username => @bar.username, :verified => @bar.verified, :zip => @bar.zip }
      post :create, :bar => @update
    end

    assert_redirected_to bar_path(assigns(:bar))
  end

  test "should show bar" do
    get :show, :id => @bar
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @bar
    assert_response :success
  end

  test "should update bar" do
    #put :update, :id => @bar, :bar => { :address => @bar.address, :city => @bar.city, :email => @bar.email, :id => @bar.id, :lat => @bar.lat, :lng => @bar.lng, :name => @bar.name, :password => @bar.password, :reference => @bar.reference, :state => @bar.state, :username => @bar.username, :verified => @bar.verified, :zip => @bar.zip }
    put :update, :id => @bar, :bar => @update
    assert_redirected_to bar_path(assigns(:bar))
  end

  test "should destroy bar" do
    assert_difference('Bar.count', -1) do
      delete :destroy, :id => @bar
    end

    assert_redirected_to bars_path
  end
end
