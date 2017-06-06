class Users::SavedListingsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_listing, only: [:create]
  before_action :set_saved_listing, only: [:destroy]

  def index # cf listings controller
    sql = "SELECT listing_name, listing_type, asking_price, address, bedrooms, size_sqft, size_sqm, published, "\
      "  a.id, cover_file_name, cover_content_type, cover_file_size, a.updated_at, status, user_id, slug "\
      "  FROM listings a, "\
      "     ( SELECT listing_id, id, created_at FROM saved_listings WHERE user_id = " + current_user.id.to_s + ") b "\
      "  WHERE a.id = b.listing_id AND a.published = 1 "\
      "  ORDER BY b.created_at DESC;"
    
    result_set = Listing.connection.execute(sql)
    fields = result_set.fields

    @listings = result_set.values.map { |value_set| # @listings akin to a array of Model instances
      # Hash[fields.zip(value_set)]
      Listing.instantiate(Hash[fields.zip(value_set)])
    }
    
    @listings = Kaminari.paginate_array( @listings).page(params[:page])
    
    @currentuser_savedlistings = SavedListing.select(:listing_id, :id).where( user_id: current_user.id).map { |i| [i.listing_id, i.id] }.to_h
  end

  def create
    if @listing.nil?
      render plain: 'Listing to save is not found', status: 404
    elsif @listing.user_id == current_user.id
      render plain: 'User must not save his own listing', status: 500
    else

      new_saved_listing = SavedListing.where("listing_id = ? AND user_id = ?", @listing.id, current_user.id).first

      if new_saved_listing # was created by user earlier in another browser
        render plain: new_saved_listing.id, status: 200
        return
      end

      # create saved_listing
      new_saved_listing = SavedListing.new( user_id: current_user.id, listing_id: @listing.id)
      new_saved_listing.save(validate: false)
      render plain: new_saved_listing.id, status: 200

    end

  end

  def destroy
    # File.open('/home/jerry/zzzzzzzz___111.txt', 'w') { |file| file.write( params[:saved_listing_id]) }
    if @saved_listing # it could have been deleted by user earlier in another browser
      @saved_listing.destroy
    end
    render plain: 'ok', status: 200
  end

  private

  def set_listing
    @listing = Listing.where("id = ?", params[:listing_id]).first
  end

  def set_saved_listing
    @saved_listing = SavedListing.where("id = ? AND user_id = ?", params[:id], current_user.id).first
  end

end
