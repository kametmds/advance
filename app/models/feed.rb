class Feed < ApplicationRecord
  validates :content, presence: true
  mount_uploader :image, ImageUploader
end
