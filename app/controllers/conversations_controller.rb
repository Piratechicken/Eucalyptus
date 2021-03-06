class ConversationsController < ApplicationController
  before_action :authenticate_user!  
  before_action :set_conversation, only: [:show, :edit, :update, :destroy]

  def index
    @conversations = Conversation.user_conversations(current_user)
  end

  def show
  end

  def create
    listing = Listing.find_by_id(params[:listing_id])
    seller = listing.user

    if params[:buyer_id]!=seller.id # Sender and Receiver should not be the same
      
      if Conversation.between(params[:buyer_id],params[:listing_id]).present? # between scope in model
        @conversation = Conversation.between(params[:buyer_id], params[:listing_id]).first
      else
        @conversation = Conversation.create!(conversation_params)
      end

      redirect_to conversation_messages_path(@conversation)

    else
      respond_to do |format|
        format.html { redirect_to listing_path(@listing), notice: 'You cannot send a message to yourself.' }
        format.json { head :no_content }
      end

    end

  end

  # PATCH/PUT /conversations/1
  # PATCH/PUT /conversations/1.json
  def update
    respond_to do |format|
      if @conversation.update(conversation_params)
        format.html { redirect_to @conversation, notice: 'Conversation was successfully updated.' }
        format.json { render :show, status: :ok, location: @conversation }
      else
        format.html { render :edit }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.json
  def destroy
    @conversation.destroy
    respond_to do |format|
      format.html { redirect_to conversations_url, notice: 'Conversation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conversation_params
      params.permit(:buyer_id, :listing_id)
    end
end
