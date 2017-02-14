$(document).ready(function() {
  var user_street_address = $('#user_street_address').get(0);

  if (user_street_address) {
    var autocomplete = new google.maps.places.Autocomplete(user_street_address, { types: ['geocode'] });
    google.maps.event.addListener(autocomplete, 'place_changed', onUserPlaceChanged);
    google.maps.event.addDomListener(user_street_address, 'keydown', function(e) {
      if (e.keyCode == 13) {
        e.preventDefault(); // Do not submit the form on Enter.
      }
    });
  }

  var property_street_address = $('#property_street_address').get(0);

  if (property_street_address) {
    var autocomplete = new google.maps.places.Autocomplete(property_street_address, { types: ['geocode'] });
    google.maps.event.addListener(autocomplete, 'place_changed', onPropertyPlaceChanged);
    google.maps.event.addDomListener(property_street_address, 'keydown', function(e) {
      if (e.keyCode == 13) {
        e.preventDefault(); // Do not submit the form on Enter.
      }
    });
  }
});

function onUserPlaceChanged() {
  var place = this.getPlace();
  var components = getAddressComponents(place);

  $('#user_street_address').trigger('blur').val(components.address);
  $('#user_zip_code').val(components.zip_code);
  $('#user_city').val(components.city);
  $('#user_state').val(components.administrative_area_level_1);
  if (components.country_code) {
    $('#user_country').val(components.country_code);
  }
}

function onPropertyPlaceChanged() {
  var place = this.getPlace();
  var components = getAddressComponents(place);

  $('#property_street_address').trigger('blur').val(components.address);
  $('#property_zip_code').val(components.zip_code);
  $('#property_city').val(components.city);
  $('#property_state').val(components.administrative_area_level_1);
  if (components.country_code) {
    $('#property_country').val(components.country_code);
  }
}

function getAddressComponents(place) {
  // If you want lat/lng, you can look at:
  // - place.geometry.location.lat()
  // - place.geometry.location.lng()

  var street_number = null;
  var route = null;
  var zip_code = null;
  var administrative_area_level_1 = null;
  var city = null;
  var country_code = null;
  for (var i in place.address_components) {
    var component = place.address_components[i];
    for (var j in component.types) {
      var type = component.types[j];
      if (type == 'street_number') {
        street_number = component.long_name;
      } else if (type == 'route') {
        route = component.long_name;
      } else if (type == 'postal_code') {
        zip_code = component.long_name;
      } else if (type == 'locality') {
        city = component.long_name;
      } else if (type == 'administrative_area_level_1') {
        state = component.long_name;
      } else if (type == 'country') {
        country_code = component.short_name;
      }
    }
  }

  return {
    address: street_number == null ? route : (street_number + ' ' + route),
    zip_code: zip_code,
    city: city,
    administrative_area_level_1: state,
    country_code: country_code
  };
}
