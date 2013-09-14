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

      $.ajax({
        type: "GET",
        url: "/cars.json",
        success: (@json)->
          for car, i in @json
            $('#car-' + car.id + ' td.address').html(car.address)
            $('#car-' + car.id + ' td.updated-at').html(car.updated_at.replace(/(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)\+(\d+):(\d+)/, '$1/$2/$3 $4:$5:$6'))
        error: (XMLHttpRequest, textStatus, errorThrown)->
          alert(errorThrown)
      })
  , 5000)
)()