require 'test_helper'

class NearbyBarsControllerTest < ActionController::TestCase
  test "should find two bars" do
    request.env['HTTP_LATITUDE'] = '1.475'
    request.env['HTTP_LONGITUDE'] = '1.475'
    
    get :index
    assert_response :success
    assert response.body == '<?xml version="1.0" encoding="UTF-8" ?><nearbybars><bar><bar_id>1</bar_id><name>MyString</name><address>MyString</address><lat>1.5</lat><lng>1.5</lng></bar><bar><bar_id>2</bar_id><name>MyString</name><address>MyString2</address><lat>1.5</lat><lng>1.5</lng></bar></nearbybars>'
  end
  
  test "should find no bars" do
    request.env['HTTP_LATITUDE'] = '100'
    request.env['HTTP_LONGITUDE'] = '100'
    
    get :index
    assert_response :success
    assert response.body == '<?xml version="1.0" encoding="UTF-8" ?><nearbybars></nearbybars>'
  end

end
