require 'test_helper'

class FbUpdateControllerTest < ActionController::TestCase
  test "should get create" do
    # Create original
    data = Hash.new
    data["id"] = "6"
    data["name"] = "Dan MacLean"
    data["first_name"] = "Dan"
    data["last_name"] = "MacLean"
    data["link"] = "http://www.facebook.com/daniel.maclean"
    data["username"] = "daniel.maclean"
    data["birthday"] = "10/21/1982"
    data["location"] = { "id", 113517895325215, "name", "Medfield, Massachusetts" }
    data["gender"] = "male"
    data["email"] = "dmaclean82@gmail.com"
    data["timezone"] = -4
    data["locale"] = "en_US"
    data["verified"] = true
    data["updated_time"] = "2011-12-05T17:39:47+0000"
    
    # Make add/update call
    user = User.new
    user.create_or_update_facebook_data(data)
    
    usercount = User.count
    fbusercount = FbUser.count
    
    # Do the update
    get :create, :json => {'id'=>'6', 'name'=>'Danno Mac', 'first_name'=>'Danno', 'last_name'=>'Mac', 'link'=>'http://www.facebook.com/daniel.maclean', 'username'=>'daniel.maclean', 'birthday'=>'08/21/1983', 'location'=>{'id'=>'113517895325215', 'name'=>'Stoughton, Kentucky'}, 'gender'=>'female', 'email'=>'dmaclean82@gmail.com', 'timezone'=>-4, 'locale'=>'en_US', 'verified'=>true, 'updated_time'=>'2011-12-05T17:39:47+0000'}.to_json
    assert_response :success
    
    usercount2 = User.count
    fbusercount2 = FbUser.count
    assert usercount == usercount2
    assert fbusercount == fbusercount2
    
    fbuser = FbUser.find_by_fb_id(data["id"])
    user = User.find(fbuser.user_id)
    
    assert user.first_name == "Danno"
    assert user.last_name == "Mac"
    assert user.dob == Date.parse("1983-08-21")
    assert user.city == "Stoughton"
    assert user.state == "KY"
    assert user.gender == "Female"
    assert user.email == "fb_dmaclean82@gmail.com"
  end

end
