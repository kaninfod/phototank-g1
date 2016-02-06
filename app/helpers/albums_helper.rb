module AlbumsHelper
  def album_selector()
    list=""
    Album.all.each do |album|
            list = list + content_tag(:li, album.name)
    end
    content_tag(:ul, list)  
  end
end
