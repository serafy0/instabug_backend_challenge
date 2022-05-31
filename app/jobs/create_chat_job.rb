class CreateChatJob < ApplicationJob
  queue_as :default

  def perform(token)
    Chat.transaction do
      chat = Chat.where(app_token: token)
      chat.lock!
      last_chat_inserted = chat.select(:number).order('number DESC').first
      chat = Chat.new({ app_token: token, number: last_chat_inserted.number + 1 })
      if chat.save!
        { json: chat.as_json(except: :id), status: :created }
      else
        { json: chat.errors, status: :unprocessable_entity }
      end
    end
  end
end
