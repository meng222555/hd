class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to user_listings_path
    else
      
      @listings = Listing.where( published: 1).where( "published_at::date > now()::date - interval '33' day").selection_columns_for_paginated_listings params[:page], 6
      # @listings = Listing.where( published: true).where( "published_at::date > now()::date - interval '11' day").selection_columns_for_paginated_listings params[:page], 6
      # @listings = Listing.where( published: true).selection_columns_for_paginated_listings params[:page], 6
    end
  end

  def list
  end

end
