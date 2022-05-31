class ChatsController < ApplicationController
  before_action :app_token
  before_action :check_token_exists
  before_action :set_chats, only: %i[create index]
  before_action :set_chat, only: %i[show]

  # GET /chats
  def index
    @chats = @chats.order(number: :asc).as_json(except: :id)
    if @chats == []
      raise ActiveRecord::RecordNotFound, app_token
    else
      render json: @chats
    end
  end

  # GET apps/chats/1
  def show
    render json: @chat
  end

  # POST apps/chats
  def create
    chat_count = 0

    last_chat_inserted = @chats.order(number: :desc).first
    chat_count = last_chat_inserted.number unless last_chat_inserted.nil?
    CreateChatJob.perform_later(app_token)
    render json: { count: chat_count + 1 }
  end

  private

  def app_token
    params[:app_id]
  end

  def check_token_exists
    raise ActiveRecord::RecordNotFound, app_token unless App.exists? token: params[:app_id]
  end

  def set_chat
    @chat = Chat.find_by!(number: params[:id], app_token: params[:app_id]).as_json(except: :id)
  end

  def set_chats
    @chats = Chat.where(app_token: app_token).select(:number)
  end

  # Only allow a list of trusted parameters through.
  def chat_params
    params.require(:chat)
  end
end
