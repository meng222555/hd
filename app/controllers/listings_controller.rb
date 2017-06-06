class ListingsController < ApplicationController
  before_action :set_listing, only: [:show]

  def index

    orig_params_q_district_id_eq = ''
    
    if params[:q].present?
      
      if params[:q][:asking_price_lt] == '5000000+'
        params[:q].delete :asking_price_lt
        params[:q].merge!( asking_price_gt: "4999999")
      elsif params[:q][:asking_price_lt] == '20000+'
        params[:q].delete :asking_price_lt
        params[:q].merge!( asking_price_gt: "19999")
      end
      
      if params[:q][:size_sqft_lt] == '5000+'
        params[:q].delete :size_sqft_lt
        params[:q].merge!( size_sqft_gt: "4999")
      end

      if params[:q][:district_id_eq].present? # format "e#" or "d#"
                                              # e for estate, d for district, # is id of estate or district

        orig_params_q_district_id_eq = params[:q][:district_id_eq] # for later view use

        district_or_estate_with_id = params[:q][:district_id_eq]
        d_or_e = district_or_estate_with_id[0] # 'd' or 'e'
        the_id = district_or_estate_with_id[-district_or_estate_with_id.length + 1..-1]

        if d_or_e == 'd'
          params[:q][:district_id_eq] = the_id
        else
          params[:q].delete :district_id_eq
          params[:q].merge!( estate_id_eq: the_id)
        end

      end
    
      ############# searchtext ...
      searchtext = params[:q][:searchtext]
      searchtext = searchtext.strip # removes leading and trailing spaces
      searchtext.gsub! /\++/, ''    # + sign is used as word delimiter at pg text search SELECT
                                    #         p 6++ ++ 6
                                    # becomes p 6  6
      searchtext.gsub! /\s+/, '+'   # becomes p+6+6
      searchtext.gsub!(/\^|\$|\?|\.|\/|\\|\[|\]|\{|\}|\(|\)|\||\*|-|_|=|%|!|,|\`|@|&|\'|\"|~|:|;/, '') # problematic chars cf SELECT
      
      if searchtext != ''
        # listings_with_keywords = Listing.select( :id).where( "searchtext @@ to_tsquery('english','#{searchtext}')").to_sql # dbug
        listings_with_keywords = Listing.select( :id).where( "searchtext @@ to_tsquery('english','#{searchtext}')").to_a.collect {|p| p.id }
        # @searchtext_dbug = listings_with_keywords # dbug
        # @searchtext_dbug = searchtext # dbug
        
        if listings_with_keywords.blank?
          params[:q].reverse_merge!(:id_eq => -999) # reverse_merge, so id's appear at start of WHERE clause, rather than at end.
        else
          params[:q].reverse_merge!(:id_in => listings_with_keywords)
        end
      end
      ############# searchtext end

    end
    
    @q = Listing.ransack(params[:q])
    @listings = @q.result.where( published: 1).selection_columns_for_paginated_listings params[:page]

    if user_signed_in?
      @currentuser_savedlistings = SavedListing.select(:listing_id, :id).where( user_id: current_user.id).map { |i| [i.listing_id, i.id] }.to_h
    end

    ######
    ### restore back original params[:q][:district_id_eq] for 'f.select' in 'district_id_eq' dddw of searchform
    ######
    if params[:q].present?
      if params[:q][:district_id_eq].present?
        params[:q][:district_id_eq] = orig_params_q_district_id_eq
      elsif params[:q][:estate_id_eq].present?
        params[:q].delete :estate_id_eq
        params[:q].merge!( district_id_eq: orig_params_q_district_id_eq)
      end
    end
  
  end

  def show
    unless @listing.published?
      redirect_to listings_path
    end
  end


  private
    def set_listing
      # @listing = Listing.where( :id => params[:id]).first
      # @listing = Listing.where( :slug => params[:id]).first
      @listing = Listing.friendly.find(params[:id])
      if @listing.nil?
        redirect_to listings_path
      end
    end
  
end
