class User < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 30 }, uniqueness: true
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
  validates :image, presence: true

  before_validation { email.downcase! }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  mount_uploader :image, ImageUploader

  has_many :feeds, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_feeds, through: :favorites, source: :feed

  has_many :active_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy
  has_many :passive_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  #指定のユーザをフォローする
  def follow!(other_user)
    active_relationships.create!(followed_id: other_user.id)
  end

  #フォローしているかどうかを確認する
  def following?(other_user)
    active_relationships.find_by(followed_id: other_user.id)
  end

  #指定のユーザーフォロー解除
  def unfollow!(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
end
