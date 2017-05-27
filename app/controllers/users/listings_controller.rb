class Users::ListingsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_listing, only: [:edit, :update, :show, :publish]

  def index
    # @listings = current_user.listings.order('published DESC, published_at DESC, created_at DESC')
    @listings = current_user.listings
  end

  def new
  end

  def update
    retrieved_listing_name = @listing.listing_name

    amenities_of_listing_submitted = Amenity.order('description').all.map { |amenity| {"id"=>amenity.id,"description"=>amenity.description,"checked"=>"#{listing_params['amenity_ids'].include?(amenity.id.to_s) ? 'y' : '' }"} }
    sceneries_of_listing_submitted = Scenery.order('description').all.map { |scenery| {"id"=>scenery.id,"description"=>scenery.description,"checked"=>"#{listing_params['scenery_ids'].include?(scenery.id.to_s) ? 'y' : '' }"} }
    features_of_listing_submitted = Feature.order('description').all.map { |feature| {"id"=>feature.id,"description"=>feature.description,"checked"=>"#{listing_params['feature_ids'].include?(feature.id.to_s) ? 'y' : '' }"} }

    if @listing.update(listing_params)
      h = @listing.attributes.except("user_id", "created_at", "updated_at")
      h.each do |key, val|
        val = val.nil? ? "":val
        h[key] = {"val"=>val, "error"=>""}
      end

      retrieved_listing_name_is_blank = @listing.listing_name.blank? ? 'true' : 'false'

      render json: { record: h, errors_summary: [], retrieved_listing_name_is_blank: retrieved_listing_name_is_blank, amenities_of_listing: amenities_of_listing_submitted, sceneries_of_listing: sceneries_of_listing_submitted , features_of_listing: features_of_listing_submitted }, status: :ok, location: @listing
    else
      h = @listing.attributes.except("user_id", "created_at", "updated_at")

      errors_summary = []

      h.each do |key, val|
        # h[key] = {"val"=>val, "error"=>"\u25CF #{rand(333)}"} # \u25CF unicode cf bullet char
        val = val.nil? ? "":val
        # h[key] = {"val"=>val, "error"=>"ERROR #{rand(7777)}"}

        if @listing.errors[key].empty?
          h[key] = {"val"=>val, "error"=>""}
        else
          h[key] = {"val"=>val, "error"=>@listing.errors[key].join(" \u25CF ")}
          @listing.errors.full_messages_for(key.to_sym).each{ |m| errors_summary.push( {"fieldname"=>'#' + @listing.class.name.underscore + '_' + key, "error"=>m}) }
        end
      end

      retrieved_listing_name_is_blank = retrieved_listing_name.blank? ? 'true' : 'false'
      # render json: { record: h, errors_summary: @listing.errors.full_messages, retrieved_listing_name_is_blank: retrieved_listing_name_is_blank }, status: :unprocessable_entity
      render json: { record: h, errors_summary: errors_summary, retrieved_listing_name_is_blank: retrieved_listing_name_is_blank, amenities_of_listing: amenities_of_listing_submitted, sceneries_of_listing: sceneries_of_listing_submitted, features_of_listing: features_of_listing_submitted }, status: :unprocessable_entity

    end
  end

  def edit
    if @listing.published?
      redirect_to user_listing_path( @listing) and return
    end

    @h = @listing.attributes.except("user_id", "created_at", "updated_at")
    @h.each do |key, val|
      val = val.nil? ? "":val
      @h[key] = {"val"=>val, "error"=>""}
    end
    # ... {"id"=>{"val"=>116, "error"=>"84"}, "listing_type"=>{"val"=>"FOR SALE", "error"=>"16"}, "listing_name"=>{"val"=>"zzzzzzzzz", "error"=>"331"}}

    # @retrieved_listing_name_is_blank = @listing.listing_name.blank? ? 'true' : 'false'
  end

  def create_a_sell
    listing = Listing.new( user_id: current_user.id, listing_type: "FOR SALE", status: "For Sale")
    #listing.skip_listing_name_validation = true
    listing.save(validate: false)
    redirect_to edit_user_listing_path( listing)
  end

  def create_a_rent
  end

  def show
  end

  def publish
    if @listing.publishable?
      @listing.update( :published => 1, :published_at => DateTime.current())
      redirect_to user_listing_path( @listing), success: 'Your listing was successfully published'
    else
      redirect_to edit_user_listing_path( @listing), warning: "Please complete your listing in order to publish it."
    end

  end


  private
    def set_listing
      @listing = Listing.where("id = ? AND user_id = ?", params[:id], current_user.id).first
      if @listing.nil?
        redirect_to user_listings_path
      end
    end

    def listing_params
      params.require(:listing).permit(:listing_name, :listing_type, :property_type_id, :property_sub_type_id, :description, :furnishing, :floor_type, :rental_type, :bedrooms, :tenure_id, :estate_id, :district_id, :district_or_estate, :address, :postal_code, :floor, :unit_no, :show_unit, :size_area, :size_unit, :bathrooms, :lat, :lng, :asking_price, :amenity_ids => [], :scenery_ids => [], :feature_ids => [])
    end

end
