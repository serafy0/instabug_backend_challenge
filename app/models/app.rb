class App < ApplicationRecord
  has_secure_token
  validates :name, presence: true, length: { maximum: 255 }
end
