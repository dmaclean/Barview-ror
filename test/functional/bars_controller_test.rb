require 'test_helper'

class BarsControllerTest < ActionController::TestCase
  setup do
    @bar = bars(:one)
    @new = {
      :name => 'Mom and Dads',
	  :address => '20 Wire Village Rd',
	  :bar_phone => '508-359-4658',
	  :bar_type => 'Pub',
	  :bar_website => 'www.bar-view.com',
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
	  :bar_phone => '508-123-4658',
	  :bar_type => 'Night Club',
	  :bar_website => 'google.com',
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
    session[:admin_id] = 1
    get :index
    assert_response :success
    assert_not_nil assigns(:bars)
  end
  
  test "should get index and verify" do
    session[:admin_id] = 1
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
    assert_match /Bar phone/, response.body
    assert_match /Bar website/, response.body
    assert_match /Sign up!/, response.body
    assert_match /I have read and agree to the/, response.body
    assert_select '#password_explanation', 0
    assert_response :success
  end

  test "should create bar" do
    assert_difference('Bar.count') do
      #post :create, :bar => { :address => @bar.address, :city => @bar.city, :email => @bar.email, :id => @bar.id, :lat => @bar.lat, :lng => @bar.lng, :name => @bar.name, :password => @bar.password, :reference => @bar.reference, :state => @bar.state, :username => @bar.username, :verified => @bar.verified, :zip => @bar.zip }
      post :create, :bar => @new
    end

    assert_redirected_to '/barhome'
  end

  test "should show bar" do
    session[:bar_id] = 1
    get :show, :id => @bar
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @bar
    assert_match /Bar phone/, response.body
    assert_match /Bar website/, response.body
    assert_match /Update info/, response.body
    assert_no_match /I have read and agree to the/, response.body
    assert_response :success
  end

  test "should update bar" do
    #put :update, :id => @bar, :bar => { :address => @bar.address, :city => @bar.city, :email => @bar.email, :id => @bar.id, :lat => @bar.lat, :lng => @bar.lng, :name => @bar.name, :password => @bar.password, :reference => @bar.reference, :state => @bar.state, :username => @bar.username, :verified => @bar.verified, :zip => @bar.zip }
    put :update, :id => @bar, :bar => @update
    
    @edited_bar = Bar.find(@bar.id)
    assert @edited_bar.bar_type == 'Night Club'
    assert @edited_bar.bar_phone == '508-123-4658'
    assert @edited_bar.bar_website == 'google.com'
    assert_redirected_to barhome_path
  end
  
  test "change password" do
    old_pw = @bar.hashed_password
    put :update, :id => @bar, :bar => { :password => 'newpass', :password_confirmation => 'newpass' }
    
    @edited_bar = Bar.find(@bar.id)
    assert @edited_bar.hashed_password != "" and @edited_bar.hashed_password != old_pw
  end
  
  test "non-admin cannot destroy bar" do
    assert_difference('Bar.count', 0) do
      delete :destroy, :id => @bar
    end
    
    assert_redirected_to '/'
  end

  test "should destroy bar" do
    session[:admin_id] = 1
  
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
    assert_select '#phone_content', '508-359-4658'
    assert_select '#website_content', 'website'
    assert_match /<a href="http:\/\/www\.bar-view\.com">website<\/a>/, response.body
    assert_select '#1', 1
    assert_select '#1_favorite', 'Remove from favorites'
    assert_select '.detail_deal', 'MyText'
  end
  
  test "detail for non-favorite" do
    session[:user_id] = 1
    get :show, :id => 4
    
    assert_response :success
    assert_select '#name_h1', 'MacLean Bar'
    assert_select '#address_content', :text => %r'51 Sleeper St\s+Boston, MA 12210'
    assert_select '#4', 1
    assert_select '#4_favorite', 'Add to favorites'
    assert_select '.detail_deal', 'I hate testing'
  end
  
  test "detail for non-existent bar" do
    session[:user_id] = 1
    get :show, :id => 99999999
    
    assert_redirected_to '/userhome'
  end
  
  # When the user is not logged in we send them to the homepage.
  test "detail user not logged in" do
    get :show, :id => 2
    assert_redirected_to '/userhome'
  end
  
  test "do not show bar list for non-admin" do
    get :index
    assert_redirected_to '/'
  end
  
  test "show bar list for admin" do
    session[:admin_id] = 1
    get :index
    assert_response :success
  end
  
  test "Show and Back links are gone" do
    get :edit, :id => 1
    assert_no_match /Show/, response.body
    assert_no_match /Back/, response.body
  end
end
