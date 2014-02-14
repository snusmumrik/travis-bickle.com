# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

Date::getMonthTwoDigits = ->
  retval = @getMonth() + 1
  if retval < 10
    "0" + retval.toString()
  else
    retval.toString()

Date::getDateTwoDigits = ->
  retval = @getDate()
  if retval < 10
    "0" + retval.toString()
  else
    retval.toString()

 Date::getHoursTwoDigits = ->
  retval = @getHours()
  if retval < 10
    "0" + retval.toString()
  else
    retval.toString()

Date::getMinutesTwoDigits = ->
  retval = @getMinutes()
  if retval < 10
    "0" + retval.toString()
  else
    retval.toString()

Date::getSecondsTwoDigits = ->
  retval = @getSeconds()
  if retval < 10
    "0" + retval.toString()
  else
    retval.toString()

$('#pickup-locations').change( ->
  $('#location_pickup_location').val($('option:selected', this).html())
  $('#location_address').val($(this).val())
  $("input[name='commit']").submit()
)

# To avoid loaded at contents_controller, the script bellow are embeded in application.html.erb

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
            # m2 = new Date(result).toLocaleString("en-GB", {year: "numeric", month: "2-digit", day: "2-digit", hour: "2-digit", minute: "2-digit", second: "2-digit"}).match(/(\d+)\/(\d+)\/(\d+) (\d+):(\d+):(\d+)/)
            # new_updated_at = m2[3] + "/" + m2[2] + "/" + m2[1] + " " + m2[4] + ":" + m2[5] + ":" + m2[6]w

            m2 = new Date(result)
            if m2.getYear() < 2000 then yyyy =  m2.getYear() + 1900 else yyyy = m2.getYear()
            mm = m2.getMonthTwoDigits()
            dd = m2.getDateTwoDigits()
            hh = m2.getHoursTwoDigits()
            ii = m2.getMinutesTwoDigits()
            ss = m2.getSecondsTwoDigits()
            new_updated_at = yyyy + "/" + mm + "/" + dd + " " + hh + ":" + ii + ":" + ss + "<br>"

            $('#car-' + car.id + ' td.address').html(car.address.replace('(null)', ''))
            $('#car-' + car.id + ' td.updated-at').html(new_updated_at)
        error: (XMLHttpRequest, textStatus, errorThrown)->
          alert(errorThrown)
      })
  , 5000)
)()
