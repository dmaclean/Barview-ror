require 'test_helper'

class MobileInfoControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    
    assert_select '#android_desc', 'The Bar-view Android app is now available on the Android Market.  Just search for \'Barview\' in the Market or scan the QR code below with an app like QR Droid.'
    assert_select '#iphone_desc', 'The Bar-view iPhone app is currently in development and we hope to make it available to you in the coming weeks.'
    assert_select '.hero-unit', 0
  end

end
