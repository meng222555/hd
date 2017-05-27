module ListingsHelper
  def form_to_create_a_sell_listing
    if user_signed_in?
      form_tag( create_a_sell_user_listings_path) do
        button_tag 'List Your Property', :class => "signup btn btn-lg btn-red", :style => "color:#fff", :type => "submit"
      end
    else
      # link_to 'List Your Property', user_listings_path, class: "signup btn btn-lg btn-red", data: { turbolinks: false }
      link_to 'List Your Property', user_listings_path, class: "signup btn btn-lg btn-red"
    end
  end

  def form_to_create_a_rent_listing
    if user_signed_in?
      form_tag( create_a_rent_user_listings_path) do
        button_tag 'List Your Property', :class => "signup btn btn-lg btn-red", :style => "color:#fff", :type => "submit"
      end
    else
      # link_to 'List Your Property', user_listings_path, class: "signup btn btn-lg btn-red", data: { turbolinks: false }
      link_to 'List Your Property', user_listings_path, class: "signup btn btn-lg btn-red"
    end
  end

  def link_for_list_a_property html_options={}
    text = "List Your Property"

    if user_signed_in?
      if current_user.listings.count > 0
        text = "List Another Property"
      else
        text = "List a Property"
      end
    end

    link_to text, list_path, html_options
  end
  
  def hashize_select_options_for_listing lookup_options
    # e.g. RENTAL_TYPES = [ nil, '', 'Whole Unit', 'Room Only']
    # becomes [{"id"=>'Whole Unit',"description"=>'Whole Unit'}, {"id"=>'Room Only',"description"=>'Room Only'}]
    lookup_options.select { |i| !i.blank? }.map { |i| {"id"=>i,"description"=>i} }
  end



  def listing_get_completeness_status listing
    unless listing.published?
      unless listing.publishable?

        if listing.cover_id
          link = link_to "#{content_tag(:p, listing.listing_name)} #{image_tag( Photo.where(:id => listing.cover_id).first.picture.url(:thumb), :size => '100x100')}".html_safe, edit_user_listing_path( listing)
        else
          link = link_to "#{content_tag(:p, listing.listing_name)} #{image_tag( Photo.default_url( :thumb), :size => '100x100')}".html_safe, edit_user_listing_path( listing)
        end

        { status: 'Draft', link_to_listing: link}

      else

        if listing.cover_id
          link = link_to "#{content_tag(:p, listing.listing_name)} #{image_tag( Photo.where(:id => listing.cover_id).first.picture.url(:thumb), :size => '100x100')}".html_safe, user_listing_path( listing)
        else
          link = link_to "#{content_tag(:p, listing.listing_name)} #{image_tag( Photo.default_url( :thumb), :size => '100x100')}".html_safe, user_listing_path( listing)
        end

        { status: 'Completed', link_to_listing: link}

      end
    else

      if listing.cover_id
        link = link_to "#{content_tag(:p, listing.listing_name)} #{image_tag( Photo.where(:id => listing.cover_id).first.picture.url(:thumb), :size => '100x100')}".html_safe, listing_path( listing)
      else
        link = link_to "#{content_tag(:p, listing.listing_name)} #{image_tag( Photo.default_url( :thumb), :size => '100x100')}".html_safe, listing_path( listing)
      end

      { status: 'Published', link_to_listing: link}

    end
  end

  def listing_get_action_buttons listing
    unless listing.published?
      unless listing.publishable?

        # 'Draft', [Edit], [Preview]
        content_tag(:div, class: "listing-action-buttons") do
          link_to( "Edit", edit_user_listing_path( listing), class: "btn btn-red btn-curve", data: { turbolinks: false }) + ' ' + 
          link_to( "Preview", user_listing_path( listing), class: "btn btn-red btn-curve", data: { turbolinks: false })
        end

      else

        # 'Completed', [Edit], [Preview], [Publish]
        content_tag(:div, class: "listing-action-buttons") do
          form_for listing, url: publish_user_listing_path( listing) do |f| 
            link_to( "Edit", edit_user_listing_path( listing), class: "btn btn-red btn-curve", data: { turbolinks: false }) + ' ' + 
            link_to( "Preview", user_listing_path( listing), class: "btn btn-red btn-curve", data: { turbolinks: false }) + ' ' + 
            '<button type="submit" class="btn btn-red btn-curve white">Publish</button>'.html_safe
          end
        end

      end

    else

      # 'Published', [View]
        content_tag(:div, class: "listing-action-buttons") do
          link_to( "View", listing_path( listing), class: "btn btn-red btn-curve")
        end
    end
  end

  def listing_get_psf_amount listing
    if listing.size_unit.blank? || listing.size_area.blank? || (listing.size_area == 0) || listing.asking_price.blank?
      ''
    elsif listing.asking_price == 0
      '0'
    elsif listing.size_unit == 'SQFT'
      psf = number_to_currency listing.asking_price/listing.size_area, :precision => 0
    else # 'SQM'
      psf = number_to_currency listing.asking_price/(listing.size_area * 10.76391042), :precision => 0
    end
  end

end
