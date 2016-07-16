class User < ActiveRecord::Base
  include Clearance::User
  acts_as_voter


end
