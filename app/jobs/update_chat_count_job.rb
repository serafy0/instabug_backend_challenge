class UpdateChatCountJob < ApplicationJob
  queue_as :default

  def perform(new_chats_count, token)
    App.find_by!(token: token).update(chats_count: new_chats_count)
  end
end
