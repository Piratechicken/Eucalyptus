class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  # GET /messages
  # GET /messages.json
  def index
    @messages = @conversation.messages.order(:created_at).last(10)
    # Manual auth... If this is not your convo, go away!
    if (current_user == @conversation.buyer) || (current_user == @conversation.seller)
      @message = @conversation.messages.new
    else
      redirect_to root_path
    end
  end

  def new
    @message = @conversation.messages.new
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = @conversation.messages.new(message_params)
    @message.user = current_user

    if @message.save
      redirect_to conversation_messages_path(@conversation)
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.find(params[:conversation_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:body)
    end
end
