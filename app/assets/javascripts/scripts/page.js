App.page = function(){
   /*
   * path /page/home_owners
   *
   */

    /*** Fades in clicked tab, fades out previous tab ***/
    $("#content .page-wrapper .page-content .nav-tabs li a.fade").click(function(){
      if( $(this).css("cursor") != 'default') {
        $("#content .page-wrapper .page-content .nav-tabs li a.fade").toggleClass("in");
      }
    });

    /*** Accordion behaviour, init all keys of accordion to folded ***/
    $("#sectionA.tab-pane .toreveal").hide();

    /*** Accordion behaviour, clicking to open a folded li won't fold any li that is already opened ***/
    $("#sectionA.tab-pane a.reveal").click(function(e){
      e.preventDefault();
      $(this).parent().next().toggle();
    });



}

$(document).ready(App.page);
// $(document).on("turbolinks:load", App.page);
