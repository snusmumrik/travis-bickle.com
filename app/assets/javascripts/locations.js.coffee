# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

(->
  setInterval(->
    if $('#map').length
      $.ajax({
        type: "GET",
        url: "/locations.json",
        success: (@json)->
          Gmaps.map.replaceMarkers(@json)
        error: (XMLHttpRequest, textStatus, errorThrown)->
          alert(errorThrown)
      })
  , 5000)
)()