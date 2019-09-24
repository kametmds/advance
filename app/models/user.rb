class User < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 30 }, uniqueness: true
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
  validates :image, presence: true

  before_validation { email.downcase! }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  mount_uploader :image, ImageUploader

  has_many :feeds
  has_many :favorites, dependent: :destroy
  has_many :favorite_feeds, through: :favorites, source: :feed
end
