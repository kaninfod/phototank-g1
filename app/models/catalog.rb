class Catalog < ActiveRecord::Base
  has_many :instances
  has_many :photos, through: :instances 
end
