class Catalog < ActiveRecord::Base
  has_many :instances, dependent: :destroy
  has_many :photos, through: :instances 

  scope :photos, -> { Photo.joins(:instances).where('catalog_id=?', self.id) }
  
end
