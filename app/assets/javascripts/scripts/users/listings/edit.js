App.Users.Listings.edit = function(){
	window.addEventListener("scroll", sticky_relocate);
}

App.Users.Listings.edit.thumbs = function(){
  //////
  // $("#upload-button").click(function(){
  $("#thumbs-gallery .upload-button").click(function(){
    $('#new_photo #photo_picture').click(); // file button
  });
  
  //////
  $('#new_photo #photo_picture').change(function( e) {
    loadFile( e);
  });

  //////
  var loadFile = function(event) {
    
    var fileform = document.getElementById( 'new_photo');
    var formData = new FormData( fileform);

    var $thumbs_modal = $('#thumbs_modal');

    $thumbs_modal.addClass("disabled");
    $('#spinner').removeClass('hide');
    
    // http://stackoverflow.com/questions/6974684/how-to-send-formdata-objects-with-ajax-requests-in-jquery
    $.ajax({
      type: "POST",
      url: $( fileform).attr( 'action') + '.js',
      cache: false,
      timeout: 5000,
      dataType: "json",
      data: formData,
      processData: false,
      contentType: false
    }).done(function(data)
    {
      $(".thumbs ul").append('<li id="photo_to_sort_' + data.id + '" class="imgli ui-sortable-handle">' + '<img class="thumb' + '" src="' + data.photo_src + '"/>' + data.link_to_destroy + '</li>');
      $( '#photo_picture', fileform).val('');
      $('#how2drag').html("Drag to re-order images. The 1st image will be used as your cover image.");
   }).fail(function(jqXHR, textStatus)
    {
      $( '#photo_picture', fileform).val('');
      alert( jqXHR.responseText);
   }).always(function()
    {
      $thumbs_modal.scrollTop($thumbs_modal.prop("scrollHeight")); // scroll to bottom
      $('#spinner').addClass('hide');
      $thumbs_modal.removeClass("disabled");
    });
    
  };
  
  //////
  $('.thumbs ul').on('click', 'a.destroy', function(e){ // middle arg needed coz 'a.destroy' will be dynamically added to existing parent ul
    e.preventDefault();
    
    // li containing photo img user had clicked on to delete
    var li = $( this).closest( 'li');
    
    $( 'img', li).addClass( "blur");

    if ( !confirm( 'Are you sure you want to delete this image?')){
      $( 'img', li).removeClass( "blur");
      return false; // without this, rails method: delete will follow
    }
    else {
      // removal assumes that rails method: delete will succeed
      // $( this).closest( 'li').remove();
      li.remove();
      
      if ( $(".thumbs img").length == 0) {
        $('#how2drag').html("You'll need at least 1 photo to get your Listing published.");
      }
      
      return true; // let rails method: delete proceed
    }
  });
  
  //////
  $(".sortable").sortable();
  $( ".sortable" ).on( "sortupdate", function( event, ui ) {
    
    var ids = $(this).sortable("serialize", { key: "x" }); // output, say, x=82&x=83&x=88
    ids = ids.replace( /x=/g, ""); // 82&83&88
    
    $( '#form_sort_photos #photos_to_sort').val( ids);
    
    var sortform = document.getElementById( 'form_sort_photos');
    var formData = new FormData( sortform);

    var $thumbs_modal = $('#thumbs_modal');

    $thumbs_modal.addClass("disabled");
    $('#spinner').removeClass('hide');

    $.ajax({
      type: "POST",
      url: $( sortform).attr( 'action') + '.js',
      cache: false,
      timeout: 5000,
      dataType: "html",
      data: formData,
      processData: false,
      contentType: false
    }).done(function(data)
    {
      // alert( data);
   }).fail(function(jqXHR, textStatus)
    {
      alert( jqXHR.responseText);
   }).always(function()
    {
      $('#spinner').addClass('hide');
      $thumbs_modal.removeClass("disabled");
    });
    
    
  } );

  /////////////////////////////////////

  $("#listing_form_component").on('click', '#media', function(e){
    e.preventDefault();
    
    var $thumbs_gallery = $('#thumbs-gallery');

    if ($thumbs_gallery.hasClass('thumbs-retrieved')) {

      if ( $(".thumbs img").length == 0) {
        $('#how2drag').html("You'll need at least 1 photo to get your Listing published.");
      }
      else {
        $('#how2drag').html("Drag to re-order images. The 1st image will be used as your cover image.");
      }
    }
    else {
      $('#how2drag').html("You'll need at least 1 photo to get your Listing published.");
    }

    var $thumbs_modal = $('#thumbs_modal').modal('show');

    if ($thumbs_gallery.hasClass('hide')) {
      $thumbs_gallery.removeClass('hide');

      if (!$thumbs_gallery.hasClass('thumbs-retrieved')) {
        $thumbs_gallery.addClass('thumbs-retrieved');

        // retrieve thumbs imgs of listing from svr
        var thumbs_url = $('#thumbs-gallery #index_url').val();
        
        $thumbs_modal.addClass("disabled");
        $('#spinner').removeClass('hide');
        
        $.ajax({
          type: "GET",
          url: thumbs_url + '.js',
          cache: false,
          timeout: 5000,
          dataType: "html"
        }).done(function(data)
        {
          $('#thumbs-gallery .thumbs ul').html(data);
       }).fail(function(jqXHR, textStatus)
        {
          alert( jqXHR.responseText);
       }).always(function()
        {
          $('#spinner').addClass('hide');
          $thumbs_modal.removeClass("disabled");

          if ( $(".thumbs img").length == 0) {
            $('#how2drag').html("You'll need at least 1 photo to get your Listing published.");
          }
          else {
            $('#how2drag').html("Drag to re-order images. The 1st image will be used as your cover image.");
          }
        });

      }
    }
  });
} // App.Users.Listings.edit.thumbs end

App.Users.Listings.edit.preview = function(){
  //////
  $(".users-listings.listings.edit #btn_preview").click(function(e){
    e.preventDefault();
    
    $("#listing_form_component").addClass("disabled");
    $('#spinner').removeClass('hide');

    var preview_url = $('.users-listings.listings.edit #preview_url').val();
    
            
    $.ajax({
      type: "GET",
      url: preview_url + '.js',
      cache: false,
      timeout: 5000,
      dataType: "html"
    }).done(function(data)
    {
      $('.users-listings.listings.edit #preview_modal .modal-body.content').html(data);
      $('.users-listings.listings.edit #preview_modal').modal('show');
      $('#map2').html( $('#map').html());
   }).fail(function(jqXHR, textStatus)
    {
      alert( jqXHR.responseText);
   }).always(function()
    {
      $('#spinner').addClass('hide');
      $("#listing_form_component").removeClass("disabled");
    });
  });

} // App.Users.Listings.edit.preview end

App.Users.Listings.edit.preview.return_to_edit = function(){
  $('.listings.edit').on("click", "#btn_edit", function(e) {
    e.preventDefault();
    $('.listings.edit #preview_modal').modal('hide');
  });

} // App.Users.Listings.edit.preview.return_to_edit end

$(document).ready(App.Users.Listings.edit);
$(document).ready(App.Users.Listings.edit.thumbs);
$(document).ready(App.Users.Listings.edit.preview);
$(document).ready(App.Users.Listings.edit.preview.return_to_edit);
// $(document).on("turbolinks:load", App.Users.Listings.edit);
// $(document).on("turbolinks:load", App.Users.Listings.edit.thumbs);
// $(document).on("turbolinks:load", App.Users.Listings.edit.preview);
// $(document).on("turbolinks:load", App.Users.Listings.edit.preview.return_to_edit);
