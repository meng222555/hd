window.App = {};

function sticky_relocate() {
  var window_top = $(window).scrollTop();
  var div_top = $('#sticky-anchor').offset().top;
  var stickable = $('#stickable');

  if (window_top > div_top) {
    stickable.addClass('sticky');
    $('#sticky-anchor').height(stickable.outerHeight());
  }
  else {
    $('#stickable').removeClass('sticky');
    $('#sticky-anchor').css('height', 0); // chrome inspector detects non-zero height
  }
}

$(document).on("click", ".errors_summary", function(e) {
  // Scrolls to field whose error was clicked by user in errors summary
  e.preventDefault();
  var formfield = $(this).attr('href'); // e.g. #listing_tenure_id
  var $formfield = $(formfield);
  var windowHeight = $(window).height();

  $('html, body').animate({
    scrollTop: $formfield.offset().top - (windowHeight / 2)
  }, 500);

  $('#errors_summary_modal').modal('hide'); // close modal
});
