require 'test_helper'

class BucketControllerTest < ActionController::TestCase
  setup do

  end

  test "can add photo to bucket" do
    get :add, {:id => 1}
    assert_not_nil session[:bucket]
    assert 1, session[:bucket].count

  end

  test "can remove from bucket" do
    get :add, {:id => 1}
    get :remove, {:id => 1}
    assert_not_nil session[:bucket]
    assert 0, session[:bucket].count
  end

  test "can empty bucket" do
    get :add, {:id => 1}
    get :clear
    assert 0, session[:bucket].count
  end

  test "can get count of bucket" do
    get :add, {:id => 1}
    get :count
    assert_response :success
  end

  test "can create album from bucket" do
    get :add, {:id => 1}
    get :add, {:id => 2}
    assert_equal 2, session[:bucket].count

    assert_difference "Album.count" do
      get :save_to_album
    end
    album = Album.last
    assert_equal [1, 2], album.photo_ids
  end

  test "can get index" do
    get :index
    assert_response :success
  end
end
