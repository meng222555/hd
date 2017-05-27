module PhotosHelper
  def link_to_destroy( photo)
    # link_to( '<i class="fa fa-trash"></i>'.html_safe, user_listing_photo_path( @listing, photo), method: :delete, remote: true, rel: :nofollow, class: "destroy", :data => { :id => photo.id, turbolinks: false })
    link_to( '<i class="fa fa-trash"></i>'.html_safe, user_listing_photo_path( @listing, photo), method: :delete, remote: true, rel: :nofollow, class: "destroy", :data => { :id => photo.id })
  end

end
