class User < ActiveRecord::Base
  acts_as_voter
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.avatar = auth['info']['image']
      user.email = auth['info']['nickname']
      if auth['info']
         user.name = auth['info']['name'] || ""
      end
    end
  end

end
