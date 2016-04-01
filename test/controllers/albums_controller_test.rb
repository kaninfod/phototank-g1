require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase

  setup do
    sign_in users(:test_user)
    @album = albums(:one)
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  # end

  test "should get edit" do
    get :edit, id: @album
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get show" do
    get :show, id: @album
    assert_response :success
  end


  test "should create album" do
    assert_difference('Album.count') do
      post :create, album: {
        name: @album.name,
        start: @album.start,
        end: @album.end,
        make: @album.make,
        model: @album.model,
        country: @album.country
      }
    end

    assert_redirected_to album_path(assigns(:album))
  end

  test "should update album" do
    patch :update, id: @album, album: {
        name: @album.name,
        start: @album.start,
        end: @album.end,
        make: @album.make,
        model: @album.model,
        country: @album.country
      }
    assert_redirected_to album_path(assigns(:album))
  end

  test "should destroy album" do
    assert_difference('Album.count', -1) do
      delete :destroy, id: @album
    end

    assert_redirected_to albums_path
  end
end
