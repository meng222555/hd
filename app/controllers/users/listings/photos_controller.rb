class Users::Listings::PhotosController < ApplicationController
# class PhotosController < ApplicationController
  # before_action :authenticate_user!, only: [ :new, :create, :destroy, :sort]
  # before_action :set_listing, only: [:new, :create, :destroy, :sort]
  before_action :authenticate_user!
  before_action :set_listing, only: [:create, :destroy, :sort, :index]
  
  # helper_method :link_to_destroy
  # include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include PhotosHelper

  def create
    @photo = @listing.photos.new( photo_params)

    respond_to do |format|
      if @photo.save

        unless @listing.cover.present?
          #@listing.skip_listing_name_validation = true
          #@listing.update cover: @photo.picture, cover_id: @photo.id
          @listing.attributes = { cover: @photo.picture, cover_id: @photo.id}
          @listing.save(validate: false)
        end
        
        format.js { render json: { "link_to_destroy": link_to_destroy( @photo), "photo_src": @photo.picture.url(:thumb), "id": @photo.id}, status: 200}
        
      else
        
        format.js {
        
          if @photo.errors.any?
          
            msg = ''
          
            @photo.errors.full_messages.each do |message|
              msg = "#{msg} | #{message}"
            end
            render json: { "errors": msg}, status: 500
          
          else
            # may not reach here if sql INSERT error, since we are using @photo.save instead of @photo.save!
            # save returns true/false, but save! raises exception which can then be caught and handled
            render json: { "errors": 'Error encountered while creating image'}, status: 500
          end
        }
        
      end
    end
  end

  def destroy
    @photo = @listing.photos.find( params[:id])
    @photo.destroy
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end

  def sort
    photos_to_sort = params[:photos_to_sort]
    photos_to_sort = params[:photos_to_sort].split('&') # split into array of photo id's
    
    # listing_id = params[:listing_id]
    # cnt = Photo.where( :id => photos_to_sort, listing_id: listing_id.to_i).count
    cnt = Photo.where( :id => photos_to_sort, listing_id: @listing.id).count
    
    if cnt != photos_to_sort.length
      render json: { errmsg: "Error encountered while sorting image" }, status: :unprocessable_entity
    else
    
      cover_id = @listing.cover_id
      
      begin
        
        # ActiveRecord::Base.transaction do
        Photo.transaction do
          photos_to_sort.each_with_index do |id, i|
          
            unless i > 0
              # chg listing cover to 1st photo if different
              if cover_id != id
                # @listing.update cover: Photo.find( id).picture, cover_id: id
                @listing.attributes = { cover: Photo.find( id).picture, cover_id: id}
                @listing.save(validate: false)
              end
            end
          
            # Photo.update( id, :seq => i) # 2 sql's here ... SELECT and UPDATE
            Photo.connection.update( "update photos set seq = #{i} where id = #{id}") # 1 sql, but will this open new connection?
                                                                                      # http://apidock.com/rails/ActiveRecord/Base/connection/class
                                                                                      # seems to indicate not
          end
        end
        
        render json: {}, status: :ok
        
      rescue => e
        logger.error "#{controller_name} #{action_name} : #{e.message}"
        render json: { errmsg: "Error encountered while sorting image" }, status: :unprocessable_entity
      end
    end
    
  end

  def index
  end


  private
    def set_listing
      # @listing = current_user.listings.find( params[:listing_id])
      # @listing = Listing.where("id = ? AND user_id = ?", params[:listing_id], current_user.id).first
      @listing = Listing.friendly.find(params[:listing_id])
      # if @listing.nil?
      if @listing.user_id != current_user.id
        redirect_to user_listings_path
      end
    end
    
    def photo_params
      params.require(:photo).permit( :picture)
    end
    
end
