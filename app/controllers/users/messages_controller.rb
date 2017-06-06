class Users::MessagesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user

  def index
    @messages = @user.messages
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end
end
