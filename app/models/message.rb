class Message < ApplicationRecord
  validates :app_token, presence: true
  validates :chat_number, presence: true
  validates :text, presence: true
end
