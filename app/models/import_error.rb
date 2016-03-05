class ImportError < ActiveRecord::Base
  serialize :errors, Array
end
