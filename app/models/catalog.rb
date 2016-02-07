class Catalog < ActiveRecord::Base
  #self.inheritance_column = :race
  has_many :instances, dependent: :destroy
  has_many :photos, through: :instances 

  scope :photos, -> { Photo.joins(:instances).where('catalog_id=?', self.id) }
  scope :master, -> { where{default.eq(true)}.first }


  
  
  validate :only_one_master_catalog

  def catalogtype
    if self.type == "LocalCatalog"
      "Local"
    elsif self.type == "DropboxCatalog"
      "Dropbox"
    end
  end

  def clone_from_catalog(from_catalog_id)
    Instance.where{catalog_id.eq(from_catalog_id)}.each do |instance|
      new_instance = instance.dup
      new_instance.catalog_id = self.id
      begin
        new_instance.save
      rescue ActiveRecord::RecordNotUnique
        logger.debug "instance exists"
      end

    end
        
  end

  def add_from_album(from_album_id)
    from_album = Album.find(from_album_id)
    
    from_album.photos.each do |photo|
      new_instance = photo.instances.first.dup
      new_instance.catalog_id = self.id
      begin
        new_instance.save
      rescue ActiveRecord::RecordNotUnique
        logger.debug "instance exists"
      end

    end
  end


  protected



  def only_one_master_catalog
    #return unless default?

    if default? and Catalog.master
      # Catalog.master.update(default: false)
    elsif not default? and  Catalog.master == self
      errors.add(:default, 'cannot have another active game')
    end
  end
  
end
