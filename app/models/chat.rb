class Chat < ApplicationRecord
  validates :app_token, presence: true
end
