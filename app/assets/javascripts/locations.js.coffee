# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('#_map').html('<%= escape_javascript( gmaps({:last_map => false}) ) %>');

Gmaps.map = new Gmaps4RailsGoogle()
Gmaps.load_map = ->
  Gmaps.map.initialize()
  Gmaps.map.map_options.language = 'ja'
  Gmaps.map.markers.data = @json
  Gmaps.map.markers.options.raw = "{animation:google.maps.Animation.BOUNCE}"
  # Gmaps.map.adjustMapToBounds()
  # Gmaps.map.callback()

(->
  t = setInterval(->
    Gmaps.loadMaps()
  , 10000)
)()