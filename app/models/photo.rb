class Photo < ApplicationRecord

  # has_attached_file :picture, styles: { medium: "650x650>", thumb: "200x200>" }, default_url: "/images/:style/missing.gif"
  # has_attached_file :picture, styles: { medium: "650x650>", thumb: "200x200>" }, default_url: "/images/:style/missing.gif", :url => "/paperclip/#{Rails.env}/pictures/:id/:style/:basename.:extension", :path => ":rails_root/public:url"
  has_attached_file :picture, styles: { medium: "650x650>", thumb: "200x200>" }, default_url: "/images/:style/missing.gif", :url => "/paperclip/#{Rails.env}/pictures/:id/:style/:basename.:extension", :path => ":rails_root/public:url"
  validates_attachment :picture, content_type: { content_type: ["image/jpeg", "image/jpg", "image/gif", "image/png"] }, size: { in: 0..8.megabytes }
  
  belongs_to :listing
  
  after_create :set_seq
  after_destroy :check_listing_cover

  def self.default_url( style)
    "/images/#{style}/missing.gif"
  end

  def set_seq
    # implemented at db trigger coz here can't handle race condition
    # aim, set seq of created photo rec to 1 plus max( seq) of existing photo recs belonging to listing_id.
  end
  
  def check_listing_cover
    # if destroyed photo isn't parent listing's cover, then exit.
    # o/w, look around for other photos belonging to listing, and pick the nearest one ( the one with the least seq).
    # If listing has no other photo, then
    #   set listing cover to nil ( paperclip will take care of deleting the cover image files)
    # else
    #   set cover to the nearest photo found ( paperclip will take care of assigning the correct image files)
    # end
    
    if listing.cover_id != id
      return
    end
    
    next_cover = Photo.select( :id).where( listing_id: listing_id, seq: ( Photo.where( listing_id: listing_id).minimum( :seq))).first
    
    if next_cover
      # Listing.find( listing_id).update cover: Photo.find( next_cover.id).picture, cover_id: next_cover.id
      listing.attributes = { cover: Photo.find( next_cover.id).picture, cover_id: next_cover.id}
      listing.save(validate: false)
    else
      # Listing.find( listing_id).update cover: nil, cover_id: nil
      listing.attributes = { cover: nil, cover_id: nil}
      listing.save(validate: false)
    end
    
  end
end
