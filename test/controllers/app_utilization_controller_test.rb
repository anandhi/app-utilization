require 'test_helper'

class AppUtilizationControllerTest < ActionController::TestCase
  test "should get cpu" do
    get :cpu
    assert_response :success
  end

end
