require 'test_helper'

class AboutControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    
    assert_select '#bv', 'Who is Bar-view?'
    assert_select '#mike', 'Mike MacLean - The brains behind the operation.'
    assert_select '#dan', 'Dan MacLean - Does the tech stuff.'
    assert_select '.hero-unit', 0
  end

end
