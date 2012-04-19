require 'test_helper'

class BarsControllerTest < ActionController::TestCase
  setup do
    @bar = bars(:one)
    @new = {
      :name => 'MyString',
	  :address => 'MyString',
	  :city => 'MyString',
	  :state => 'MyString',
	  :zip => '12345',
	  :lat => 1.5,
	  :lng => 1.5,
	  :username => 'MyString2',
	  :password => 'MyString',
	  :password_confirmation => 'MyString',
	  :email => 'dmaclean@bar-view.com',
	  :reference => 'MyText',
	  :verified => 1
    }
    @update = {
      :name => 'MyString',
	  :address => 'MyString',
	  :city => 'MyString',
	  :state => 'MyString',
	  :zip => '12345',
	  :lat => 1.5,
	  :lng => 1.5,
	  :username => 'MyString2',
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
      post :create, :bar => @new
    end

    assert_redirected_to bars_path
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
    assert_redirected_to bars_path
  end

  test "should destroy bar" do
    imagecount = Barimage.count
    eventcount = BarEvent.count
    
    assert_difference('Bar.count', -1) do
      delete :destroy, :id => @bar
    end
    
    imagecount2 = Barimage.count
    eventcount2 = BarEvent.count
    assert imagecount > imagecount2
    assert eventcount > eventcount2

    assert_redirected_to bars_path
  end
end
