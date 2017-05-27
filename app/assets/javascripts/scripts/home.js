App.home = function(){

    /*** Chrome fix; hover color not working, color held back by style color ***/
    $(".list #sell_button").mouseenter(function(e){
      text_color = util.rgb2hex( $(this).css("color"));
      
      if( text_color == "#e43455" || text_color == "#E43455"){
        $(this).css("color", "#fff");
      }
    });

    $(".list #sell_button").mouseleave(function(e){
      text_color = util.rgb2hex( $(this).css("color"));
      
      if( text_color == "#ffffff" || text_color == "#fff"){
        reddish = $(this).css("border-color");
        reddish = util.rgb2hex( reddish);
        $(this).css("color", reddish);
      }
    });

    // ... ditto #rent_button button
    $(".list #rent_button").mouseenter(function(e){
      text_color = util.rgb2hex( $(this).css("color"));
      
      if( text_color == "#e43455" || text_color == "#E43455"){
        $(this).css("color", "#fff");
      }
    });

    $(".list #rent_button").mouseleave(function(e){
      text_color = util.rgb2hex( $(this).css("color"));
      
      if( text_color == "#ffffff" || text_color == "#fff"){
        reddish = $(this).css("border-color");
        reddish = util.rgb2hex( reddish);
        $(this).css("color", reddish);
      }
    });

    /*** Show section #sell_options when #sell_button button clicked ***/
    $(".list #sell_button").click(function(e){
      e.preventDefault();
      text_color = util.rgb2hex( $(this).css("color"));
      
      if( text_color == "#000" || text_color == "#000000"){
        return;
      }

      $(".list #start").hide();
      $(".list #sell").show();
      $(".list #rent").hide();

      $(this).css("color", "#000");

      reddish = $(this).css("border-color");
      reddish = util.rgb2hex( reddish);
      $(".list #rent_button").css("color", reddish);

      $(".list #sell_options").show();
      $(".list #rent_options").hide();

      $(".list #sell_options").removeClass( "fade in");

      // $(".list #sell_options").addClass( "fade in");
      setTimeout(function(){ $(".list #sell_options").addClass( "fade in"); }, 1000);
      
    });

    /*** Show section #rent_options when #rent_button button clicked ***/
    $(".list #rent_button").click(function(e){
      e.preventDefault();
      text_color = util.rgb2hex( $(this).css("color"));
      
      if( text_color == "#000" || text_color == "#000000"){
        return;
      }

      $(".list #start").hide();
      $(".list #sell").hide();
      $(".list #rent").show();

      $(this).css("color", "#000");

      reddish = $(this).css("border-color");
      reddish = util.rgb2hex( reddish);
      $(".list #sell_button").css("color", reddish);

      $(".list #rent_options").show();
      $(".list #sell_options").hide();

      $(".list #rent_options").removeClass( "fade in");

      // $(".list #rent_options").addClass( "fade in");
      setTimeout(function(){ $(".list #rent_options").addClass( "fade in"); }, 1000);
      
    });


}

$(document).ready(App.home);
// $(document).on("turbolinks:load", App.home);
