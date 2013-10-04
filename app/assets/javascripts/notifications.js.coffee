# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# getNotifications = ->
#   $.ajax({
#     type: "GET",
#     url: "/notifications/api_index.json",
#     success: (@json)->
#       $('div.alert').fadeOut('slow', ->
#         $(this).html('')
#         )

#       if @json.error != "not found"
#         for notification in @json
#           if notification.accepted_at
#             $('.container').eq(1).prepend('<div class="alert alert-success"><p id="notice"></p></div>')
#             $('#notice').hide().append('<li>' + notification.name + '号車が「' + notification.text + '」を了承しました。'  + '</li>').fadeIn('slow')
#           else if notification.canceled_at
#             $('.container').eq(1).prepend('<div class="alert alert-error"><p id="notice"></p></div>')
#             $('#notice').hide().append('<li>' + notification.name + '号車が「' + notification.text + '」を辞退しました。'  + '</li>').fadeIn('slow')
#     error: (XMLHttpRequest, textStatus, errorThrown)->
#       # alert(errorThrown)
#   })

#   setTimeout getNotifications, 10000

# $ ->
#   setTimeout getNotifications, 10000
