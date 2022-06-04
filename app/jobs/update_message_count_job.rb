class UpdateMessageCountJob < ApplicationJob
  queue_as :default

  def perform(new_messages_count, token, number)
    Chat.find_by!(token: token, number: number).update(messages_count: new_messages_count)
  end
end
