class Job < ActiveRecord::Base
  serialize :arguments, Array

end
