class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  acts_as_voter

  after_save :invalidate_cache

  def self.serialize_from_session(key, salt)

    single_key = key.is_a?(Array) ? key.first : key
    Rails.cache.fetch("user:#{single_key}") do
       User.where(:id => single_key).entries.first
    end
  end

  private
    def invalidate_cache
      Rails.cache.delete("user:#{id}")
    end


end
