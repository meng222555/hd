App.Util = App.Util || {};
App.Util.GoogleMaps = App.Util.GoogleMaps || {};

App.Util.GoogleMaps.PlacesSearchBox = (function() {
  var map;
  var input_edit;
  var searchBox;
  // var getMap: function() {
  //   return map;
  // };

  return {
    setMap: function(user_map) {
      map = user_map;
      map.addListener('bounds_changed', function() {
        searchBox.setBounds(map.getBounds());
      });

    },
    getPlaceLat: function() {
      var places = searchBox.getPlaces();

      if (!places) {
        return '';
      }

      if (places.length == 0) {
        return '';
      }
      return places[0].geometry.location.lat();
    },
    getPlaceLng: function() {
      var places = searchBox.getPlaces();

      if (!places) {
        return '';
      }

      if (places.length == 0) {
        return '';
      }
      return places[0].geometry.location.lng();
    },
    init: function() {
      if(document.getElementById('pac-input'))
      {
        searchBox = searchBox || new google.maps.places.SearchBox( document.getElementById('pac-input'));
      }
      else
      {
        $('body').append('<input id="pac-input" hidden type="text" placeholder="Search Box">');
        searchBox = new google.maps.places.SearchBox( document.getElementById('pac-input'));
      }
      // alert('init init');
      input_edit = document.getElementById('pac-input');

      var markers = [];
      // Listen for the event fired when the user selects a prediction and retrieve
      // more details for that place.
      searchBox.addListener('places_changed', function() {
        var places = searchBox.getPlaces();
        
        if (places.length == 0) {
          return;
        }
        
        // Clear out the old markers.
        if(markers.length > 0) {
          markers.forEach(function(marker) {
            marker.setMap(null);
          });
        }
        markers = [];
        
        // For each place, get the icon, name and location.
        var bounds = new google.maps.LatLngBounds();
        
        places.forEach(function(place) {
          if (!place.geometry) {
            console.log("Returned place contains no geometry");
            return;
          }
          
          var icon = {
            url: place.icon,
            size: new google.maps.Size(71, 71),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(17, 34),
            scaledSize: new google.maps.Size(25, 25)
          };
          
          // Create a marker for each place.
          markers.push(new google.maps.Marker({
            map: map,
            icon: icon,
            title: place.name,
            position: place.geometry.location
          }));

          if (place.geometry.viewport) {
            // Only geocodes have viewport.
            bounds.union(place.geometry.viewport);
          } else {
            bounds.extend(place.geometry.location);
          }
        });
        // maps.forEach( function fitBoundsToMap(map) { map.fitBounds(bounds); } );
        map.fitBounds(bounds);
      });
    }, // init end
    search: function(text) {
      $(input_edit).attr( 'value', text);
      // alert('search ' + text);
      google.maps.event.trigger( input_edit, 'focus');
      google.maps.event.trigger( input_edit, 'keydown', {keyCode:13});
    } // search end
  };

})();


$(document).ready(App.Util.GoogleMaps.PlacesSearchBox.init);
// $(document).on("turbolinks:load", App.Util.GoogleMaps.PlacesSearchBox.init);
