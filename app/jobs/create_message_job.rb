class CreateMessageJob < ApplicationJob
  queue_as :default

  def perform(token, chat_number, text)
    Message.transaction do
      message_count = 0
      last_message_inserted = Message.where(app_token: token,
                                            chat_number: chat_number).select(:number).order(number: :desc).first
      message_count = last_message_inserted.number unless last_message_inserted.nil?
      message = Message.new({ app_token: token, chat_number: chat_number, number: message_count + 1,
                              text: text })
      UpdateMessageCountJob.set(wait: 1.minutes).perform_later(message_count + 1, token) if message.save!
    end
  end
end
