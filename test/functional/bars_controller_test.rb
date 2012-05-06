require 'test_helper'

class BarsControllerTest < ActionController::TestCase
  setup do
    @bar = bars(:one)
    @new = {
      :name => 'Mom and Dads',
	  :address => '20 Wire Village Rd',
	  :city => 'Spencer',
	  :state => 'MA',
	  :zip => '01562',
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
	  :address => '51 North St',
	  :city => 'Medfield',
	  :state => 'MA',
	  :zip => '02052',
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
  
  test "should get index and verify" do
    get :index, :verify => 3
    assert_response :success
    assert_not_nil assigns(:bars)
    assert flash[:notice] == "Successfully verified Unverified Bar"
    for bar in assigns(:bars) do
      if bar.id == 3
        assert bar.verified == 1
      end
    end
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
    session[:bar_id] = 1
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
    favecount = Favorite.count
    
    assert_difference('Bar.count', -1) do
      delete :destroy, :id => @bar
    end
    
    imagecount2 = Barimage.count
    eventcount2 = BarEvent.count
    favecount2 = Favorite.count
    assert imagecount > imagecount2
    assert eventcount > eventcount2
    assert favecount > favecount2

    assert_redirected_to bars_path
  end
  
  test "detail for favorite" do
    session[:user_id] = 1
    get :show, :id => 1
    assert_response :success
    
    assert_select '#name_h1', 'MyString'
    assert_select '#address_content', :text => %r'MyString\s+MyString, MyString 668'	# No clue why 668 keeps coming up
    assert_select '#1', 1
    assert_select '#1_favorite', 'Remove from favorites'
    assert_select '.detail_deal', 'MyText'
  end
  
  test "detail for non-favorite" do
    session[:user_id] = 1
    get :show, :id => 2
    
    assert_response :success
    assert_select '#name_h1', 'MyString'
    assert_select '#address_content', :text => %r'MyString2\s+MyString, MyString 98765'
    assert_select '#2', 1
    assert_select '#2_favorite', 'Add to favorites'
    assert_select '.detail_deal', 'MyText2'
  end
  
  test "detail for non-existent bar" do
    session[:user_id] = 1
    get :show, :id => 99999999
    
    assert_redirected_to '/userhome'
  end
  
  # When the user is not logged in we send them to the homepage.
  test "detail user not logged in" do
    get :show
    assert_redirected_to '/userhome'
  end
end
