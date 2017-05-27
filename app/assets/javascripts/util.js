/*
 * http://wowmotty.blogspot.sg/2009/06/convert-jquery-rgb-output-to-hex-color.html
 * Usage
 *   document.write( rgb2hex($('#myElement').css('background-color')) );
 *   outputs: #222222
 *
 */
/* function rgb2hex(orig){
 var rgb = orig.replace(/\s/g,'').match(/^rgba?\((\d+),(\d+),(\d+)/i);
 return (rgb && rgb.length === 4) ? "#" +
  ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
  ("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
  ("0" + parseInt(rgb[3],10).toString(16)).slice(-2) : orig;
}
*/

var util = (function() {
 
  // var a_private_id = 0;
 
  return {
    rgb2hex: function(orig) {
      var rgb = orig.replace(/\s/g,'').match(/^rgba?\((\d+),(\d+),(\d+)/i);
			return (rgb && rgb.length === 4) ? "#" +
			  ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
			  ("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
			  ("0" + parseInt(rgb[3],10).toString(16)).slice(-2) : orig;
    },

      // a_public_fn_to_reset_private_id: function() {
      //     a_private_id = 0;
      // }
  };  
})(); 
