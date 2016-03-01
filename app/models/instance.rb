class Instance < ActiveRecord::Base
  belongs_to :catalog
  belongs_to :photo

end
