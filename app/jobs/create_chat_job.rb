class CreateChatJob < ApplicationJob
  queue_as :default

  def perform(token)
    Chat.transaction do
      chat_count = 0
      last_chat_inserted = Chat.where(app_token: token).select(:number).order(number: :desc).first
      chat_count = last_chat_inserted.number unless last_chat_inserted.nil?
      chat = Chat.new({ messages_count: 0, app_token: token, number: chat_count + 1 })
      UpdateChatCountJob.set(wait: 1.minutes).perform_later(chat_count + 1, token) if chat.save!
    end
  end
end
