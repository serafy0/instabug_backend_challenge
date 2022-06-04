class CreateChatJob < ApplicationJob
  queue_as :default

  def perform(token)
    Chat.transaction do
      chat_count = 0
      last_chat_inserted = Chat.where(app_token: token).select(:number).order(number: :desc).first
      chat_count = last_chat_inserted.number unless last_chat_inserted.nil?
      chat = Chat.new({ app_token: token, number: chat_count + 1 })
      chat.save!
    end
  end
end
