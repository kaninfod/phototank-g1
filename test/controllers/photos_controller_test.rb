require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  setup do
    sign_in users(:test_user)
    @photo = photos(:one)
    @photo_no_location = photos(:two)
    @photo_reuse_location = photos(:three)
  end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end


  # test "should create photo" do
  #   assert_difference('Photo.count') do
  #     post :create, photo: {
  #         filename: @photo.filename,
  #         date_taken: @photo.date_taken,
  #         path: @photo.path,
  #         file_extension: @photo.file_extension,
  #         file_thumb_path: @photo.file_thumb_path,
  #         file_size: @photo.file_size,
  #         location_id: @photo.location_id,
  #         make: @photo.make,
  #         model: @photo.model,
  #         original_height: @photo.original_height,
  #         original_width: @photo.original_width,
  #         longitude: @photo.longitude,
  #         latitude: @photo.latitude
  #     }
  #
  #   end
  #   assert_redirected_to photo_path(assigns(:photo))
  #
  # end

  test "should show photo" do
    get :show, id: @photo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @photo
    assert_response :success
  end

  test "should update photo" do
    patch :update, id: @photo, photo: { date_taken: @photo.date_taken, filename: @photo.filename, path: @photo.path }
    assert_redirected_to photo_path(assigns(:photo))
  end

  # test "should destroy photo" do
  #   assert_difference('Photo.count', -1) do
  #     delete :destroy, id: @photo
  #   end
  #
  #   assert_redirected_to photos_path
  # end



end
