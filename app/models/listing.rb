class Listing < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  default_scope { order('listings.published DESC, listings.published_at DESC, listings.created_at DESC') }
  scope :selection_columns_for_paginated_listings, -> (pageno, per = Kaminari.config.default_per_page) { select( "listing_name, listing_type, asking_price, address, bedrooms, size_sqft, size_sqm, published, id, cover_file_name, cover_content_type, cover_file_size, listings.updated_at, status, user_id, slug").page( pageno).per( per).all }

  # has_attached_file :cover, styles: { medium: "500x500>", thumb: "200x200>" }, default_url: "/images/:style/missing.png"
  # has_attached_file :cover, styles: { medium: "600x600>" }, default_url: "/images/:style/missing.jpg"
  # has_attached_file :cover, styles: { medium: "600x600>" }, default_url: "/images/:style/missing.jpg", :url => "/paperclip/#{Rails.env}/covers/:id/:style/:basename.:extension", :path => ":rails_root/public:url"
  has_attached_file :cover, styles: { medium: "600x600>" }, default_url: "/images/:style/missing.jpg", :url => "/paperclip/#{Rails.env}/covers/:id/:style/:basename.:extension", :path => ":rails_root/public:url"
  validates_attachment :cover, content_type: { content_type: ["image/jpeg", "image/jpg", "image/gif", "image/png"] }, size: { in: 0..8.megabytes }

  LISTING_TYPES = ['FOR SALE', 'FOR RENT']
  RENTAL_TYPES = [ nil, '', 'Whole Unit', 'Room Only']
  FURNISHING_TYPES = [ nil, '', 'Unfurnished', 'Partially Furnished', 'Fully Furnished']
  FLOOR_TYPES = [ nil, '', 'Ground', 'Low', 'Middle', 'High', 'Penthouse']
  PUBLISHED = [0, 1] # 0 false

  validates_presence_of :listing_name, unless: :skip_listing_name_validation
  validates_presence_of :property_type_id
  validates :listing_type, :inclusion => {:in => LISTING_TYPES}
  validates :rental_type, :inclusion => {:in => RENTAL_TYPES, :message => " must be one of #{RENTAL_TYPES.select { |i| !i.blank? }.map { |i| i }.join(', ')} if entered"}
  validates :furnishing, :inclusion => {:in => FURNISHING_TYPES, :message => " must be one of #{FURNISHING_TYPES.select { |i| !i.blank? }.map { |i| i }.join(', ')} if entered"}
  validates :floor_type, :inclusion => {:in => FLOOR_TYPES, :message => " must be one of #{FLOOR_TYPES.select { |i| !i.blank? }.map { |i| i }.join(', ')} if entered"}
  validates :published, :inclusion => {:in => PUBLISHED}

  attr_accessor :skip_listing_name_validation

# for testing
# validates_length_of :listing_name, :minimum => 5, :maximum => 5
# validates :property_type_id, numericality: { less_than_or_equal_to: 2,  only_integer: true }
# validates :property_sub_type_id, numericality: { less_than_or_equal_to: 22,  only_integer: true, allow_blank: true }
# validates_presence_of :bedrooms
# validates_presence_of :bathrooms
# validates_presence_of :tenure_id
# validates :estate_id, numericality: { less_than_or_equal_to: 10,  only_integer: true, allow_blank: true }
# validates :district_id, numericality: { less_than_or_equal_to: 16,  only_integer: true, allow_blank: true }
# validates_presence_of :address
# validates_presence_of :postal_code
# validates_length_of :postal_code, :minimum => 6, :maximum => 6
# # validates_presence_of :floor

  belongs_to :user
  has_many :saved_listings
  has_and_belongs_to_many :amenities
  has_and_belongs_to_many :sceneries
  has_and_belongs_to_many :features
  has_many :photos
  
  # lookups
  belongs_to :property_type, optional: true
  belongs_to :property_sub_type, optional: true
  belongs_to :tenure, optional: true
  belongs_to :district, optional: true
  belongs_to :estate, optional: true

  # Your listing is ready to go live
  #
  # If everything looks good, go ahead and publish your listing!

  def publishable?
    self.completed?
  end

  def completed?
    listing_name.blank? || property_type_id.blank? || address.blank? || postal_code.blank? || asking_price.blank? || property_sub_type_id.blank? || tenure_id.blank? || size_area.blank? || bedrooms.blank? || bathrooms.blank? || floor_type.blank? || furnishing.blank? || cover_id.blank? ? false : true
  end

  def published?
    if published == 0
      return false
    else
      return true
    end
  end
  
  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :listing_name
    ]
  end

end
