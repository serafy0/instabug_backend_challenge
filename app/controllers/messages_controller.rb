class MessagesController < ApplicationController
  before_action :check_token_exists

  before_action :set_message, only: %i[show update destroy]

  # GET apps/[app_token]/chats/[chat_number]/messages
  def index
    @messages = Message.where(app_token: params[:app_id],
                              chat_number: params[:chat_id]).order(number: :asc).as_json(except: :id)
    raise ActiveRecord::RecordNotFound if @messages == []

    render json: @messages
  end

  # GET apps/[app_token]/chats/[chat_number]/messages/message_number
  def show
    render json: @message.as_json(except: :id)
  end

  # POST apps/[app_token]/chats/[chat_number]/messages
  def create
    message_count = 0
    last_message_inserted = Message.where(chat_number: params[:chat_id],
                                          app_token: params[:app_id]).select(:number).order(number: :desc).first
    message_count = last_message_inserted.number unless last_message_inserted.nil?
    CreateMessageJob.perform_later(params[:app_id], params[:chat_id], message_params[:text])

    render json: { count: message_count + 1 }
  end

  # PATCH/PUT apps/[app_token]/chats/[chat_number]/messages/[message_number]
  def update
    if @message.update(message_params)
      render json: @message.as_json(except: :id)
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def search
    result = Message.search(query: {
                              bool: {
                                filter: {
                                  terms: {
                                    app_token: params[:app_id],
                                    chat_number: params[:chat_id].to_s
                                  }
                                },

                                must: {
                                  match: {
                                    text: params[:text]
                                  }
                                }

                              }
                            }).records
    render json: result
  end

  private

  def set_message
    @message = Message.find_by!(number: params[:id], app_token: params[:app_id], chat_number: params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:text)
  end

  def check_token_exists
    raise ActiveRecord::RecordNotFound, params[:chat_id] unless Chat.exists? app_token: params[:app_id],
                                                                             number: params[:chat_id]
  end
end
