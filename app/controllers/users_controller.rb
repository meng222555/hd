class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user

  def edit
  end
  
  def update
    if @user.update(user_params)
      
      render json: { dummy: '' }, status: :ok, location: @user
    else
      user_fields = @user.attributes.select {|k,v| ["first_name", "last_name", "email"].include?(k) }
      h = user_fields.map{ |k,v| ["#{@user.class.name.underscore}_#{k}", ''] }.to_h

      errors_summary = []

      user_fields.each do |key, val|
        if @user.errors[key.to_sym].empty?
          h["#{@user.class.name.underscore}_#{key}"] = ""
        else
          h["#{@user.class.name.underscore}_#{key}"] = @user.errors[key.to_sym].join(" \u25CF ")
          # @user.errors.full_messages_for(key.to_sym).each{ |m| errors_summary.push( {'#' + @user.class.name.underscore + '_' + key => m}) }
          @user.errors.full_messages_for(key.to_sym).each{ |m| errors_summary.push( ['#' + @user.class.name.underscore + '_' + key , m]) }
        end
      end
      
      if @user.errors[:email_confirmation].empty?
        h.merge!( "#{@user.class.name.underscore}_email_confirmation" => "")
      else
        h.merge!( "#{@user.class.name.underscore}_email_confirmation" => @user.errors.full_messages_for(:email_confirmation).join(" \u25CF "))
        # @user.errors.full_messages_for(:email_confirmation).each{ |m| errors_summary.push( {'#' + @user.class.name.underscore + '_email_confirmation'  => m}) }
        @user.errors.full_messages_for(:email_confirmation).each{ |m| errors_summary.push( ['#' + @user.class.name.underscore + '_email_confirmation' , m]) }
      end
      
      render json: { field_errors: h, errors_summary: errors_summary }, status: :unprocessable_entity

    end

  end

private
  def set_user
    @user = current_user
  end
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :email_confirmation, :address, :postal_code, :phone)
  end
end
