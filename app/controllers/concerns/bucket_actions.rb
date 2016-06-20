module BucketActions
  extend ActiveSupport::Concern

  def add_comment_photo(photo_id, comment_string)
    photo = Photo.find(photo_id)
    comment = photo.comments.create
    comment.comment = comment_string
    comment.user_id = current_user.id
    comment.save
    
    photo.objective_list.add comment_string.scan(/(^\#|(?<=\s)\#\w+)/).join(',')
    photo.tag_list.add comment_string.scan(/(^\@|(?<=\s)\@\w+)/).join(',')
    photo.save
    return comment
  end

end
