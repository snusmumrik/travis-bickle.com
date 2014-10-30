# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

(->
  $("#credit").html(String(parseInt($("#report_sales").val()) + parseInt($("#report_extra_sales").val()) + parseInt($("#report_surplus_funds").val())).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))

  $("#debit").html(String(parseInt($("#report_cash").val()) + parseInt($("#report_edy").val()) + parseInt($("#report_ticket").val()) + parseInt($("#report_advance").val()) + parseInt($("#report_fuel_cost").val()) + parseInt($("#report_account_receivable").val()) + parseInt($("#report_deficiency_account").val())).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
)()

# $("input[id^='report']").change( ->
#   alert "changed"
# )

$("input[id^='report_']").change( ->
  $("#credit").html(String(parseInt($("#report_sales").val()) + parseInt($("#report_extra_sales").val()) + parseInt($("#report_surplus_funds").val())).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
  $("#report_cash").val($("#credit").html().replace(",", "") - $("#report_edy").val() - $("#report_ticket").val() - $("#report_advance").val() - $("#report_fuel_cost").val() - $("#report_account_receivable").val() - $("#report_deficiency_account").val())

  $("#debit").html(String(parseInt($("#report_cash").val()) + parseInt($("#report_edy").val()) + parseInt($("#report_ticket").val()) + parseInt($("#report_advance").val()) + parseInt($("#report_fuel_cost").val()) + parseInt($("#report_account_receivable").val()) + parseInt($("#report_deficiency_account").val())).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
)

$("#report_car_id").change( ->
  $.ajax({
  type: "GET",
  url: "/api/meters.json?car_id=#{$(this).val()}&year=#{$('#report_started_at_1i').val()}&month=#{$('#report_started_at_2i').val()}&day=#{$('#report_started_at_3i').val()}&hour=#{$('#report_started_at_4i').val()}&minute=#{$('#report_started_at_5i').val()}",
  success: (@json)->
    $("#meter").html(String(@json["meter"].meter).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
    $("#mileage").html(String(@json["meter"].mileage).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
    $("#riding_mileage").html(String(@json["meter"].riding_mileage).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
    $("#riding_count").html(String(@json["meter"].riding_count).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
    $("#meter_fare_count").html(String(@json["meter"].meter_fare_count).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
  error: (XMLHttpRequest, textStatus, errorThrown)->
    alert(errorThrown)
  })
)

$("select[id^='report_started_at_']").change( ->
  $.ajax({
  type: "GET",
  url: "/api/meters.json?car_id=#{$("#report_car_id").val()}&year=#{$('#report_started_at_1i').val()}&month=#{$('#report_started_at_2i').val()}&day=#{$('#report_started_at_3i').val()}&hour=#{$('#report_started_at_4i').val()}&minute=#{$('#report_started_at_5i').val()}",
  success: (@json)->
    $("#meter").html(String(@json["meter"].meter).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
    $("#mileage").html(String(@json["meter"].mileage).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
    $("#riding_mileage").html(String(@json["meter"].riding_mileage).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
    $("#riding_count").html(String(@json["meter"].riding_count).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
    $("#meter_fare_count").html(String(@json["meter"].meter_fare_count).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
  error: (XMLHttpRequest, textStatus, errorThrown)->
    alert(errorThrown)
  })
)

$("#report_meter").change( ->
  $("#meter_diff").html("（#{$(this).val() - parseInt($('#meter').html().replace(',', ''))}）")
)

$("#report_mileage").change( ->
  $("#mileage_diff").html("（#{$(this).val() - parseInt($('#mileage').html().replace(',', ''))}）")
)

$("#report_riding_mileage").change( ->
  $("#riding_mileage_diff").html("（#{$(this).val() - parseInt($('#riding_mileage').html().replace(',', ''))}）")
)

$("#report_riding_count").change( ->
  $("#riding_count_diff").html("（#{$(this).val() - parseInt($('#riding_count').html().replace(',', ''))}）")
)

$("#report_meter_fare_count").change( ->
  $("#meter_fare_count_diff").html("（#{$(this).val() - parseInt($('#meter_fare_count').html().replace(',', ''))}）")
)