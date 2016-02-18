class Catalog < ActiveRecord::Base
  #self.inheritance_column = :race
  serialize :watch_path, Array
  serialize :sync_from_albums, Array

  has_many :instances
  has_many :photos, through: :instances

  scope :photos, -> { Photo.joins(:instances).where('catalog_id=?', self.id) }
  scope :master, -> { where{default.eq(true)}.first }

  validate :only_one_master_catalog

  def catalogtype
    case self.type
    when "LocalCatalog"
      "Local"
    when "DropboxCatalog"
      "Dropbox"
    when "MasterCatalog"
      "Master"
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
