class Double < ActiveRecord::Base
  serialize :items, JSON
end
