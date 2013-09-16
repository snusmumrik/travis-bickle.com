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
            d = new Date()
            # クライアントPCシステム時刻
            localTime = d.getTime()
            # localTimeのタイムゾーン差分（ミリ秒）
            localOffset = d.getTimezoneOffset() * 60000
            # UTC時刻（ミリ秒）
            utc = localTime + localOffset
            # 考慮したいタイムゾーンの差分（時間）
            offset = -9.0
            # これで目的のミリ秒がでるので
            m = car.locations_updated_at.match(/(\d+)-(\d+)-(\d+)[^0-9](\d+):(\d+):(\d+)[^0-9]/)
            updated_at = new Date(m[1], m[2] - 1, m[3], m[4], m[5], m[6])
            # result = utc - (3600000 * offset)
            result = updated_at - (3600000 * offset)
            m2 = new Date(result).toLocaleString("en-GB", {year: "numeric", month: "2-digit", day: "2-digit", hour: "2-digit", minute: "2-digit", second: "2-digit"}).match(/(\d+)\/(\d+)\/(\d+) (\d+):(\d+):(\d+)/)
            new_updated_at = m2[3] + "/" + m2[2] + "/" + m2[1] + " " + m2[4] + ":" + m2[5] + ":" + m2[6]

            $('#car-' + car.id + ' td.address').html(car.address)
            $('#car-' + car.id + ' td.updated-at').html(new_updated_at)
        error: (XMLHttpRequest, textStatus, errorThrown)->
          alert(errorThrown)
      })
  , 5000)
)()