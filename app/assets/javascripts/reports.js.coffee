# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

(->
  $("#debit").html(String(parseInt($("#report_cash").val()) + parseInt($("#report_edy").val()) + parseInt($("#report_ticket").val()) + parseInt($("#report_advance").val()) + parseInt($("#report_fuel_cost").val()) + parseInt($("#report_account_receivable").val())).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))

  $("#credit").html(String(parseInt($("#report_sales").val()) + parseInt($("#report_extra_sales").val()) + parseInt($("#report_surplus_funds").val())).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
)()

# $("input[id^='report']").change( ->
#   alert "changed"
# )

$("input[id^='report_']").change( ->
  $("#debit").html(String(parseInt($("#report_cash").val()) + parseInt($("#report_edy").val()) + parseInt($("#report_ticket").val()) + parseInt($("#report_advance").val()) + parseInt($("#report_fuel_cost").val()) + parseInt($("#report_account_receivable").val())).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))

  $("#credit").html(String(parseInt($("#report_sales").val()) + parseInt($("#report_extra_sales").val()) + parseInt($("#report_surplus_funds").val())).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,'))
)