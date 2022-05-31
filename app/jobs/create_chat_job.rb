class CreateChatJob < ApplicationJob
  queue_as :default

  def perform(token)
    Chat.transaction do
      chat_count = 0
      last_chat_inserted = Chat.where(app_token: token).select(:number).order('number DESC').first
      chat_count = last_chat_inserted.number unless last_chat_inserted.nil?

      chat = Chat.new({ app_token: token, number: chat_count + 1 })
      if chat.save!
        { json: chat.as_json(except: :id), status: :created }
      else
        { json: chat.errors, status: :unprocessable_entity }
      end
    end
  end
end
