App.meeting = App.cable.subscriptions.create {
  channel: "MeetingChannel"
  id: window.meeting.id
},
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    alert "Received: #{data['image']}"

  send_image: (filename, image, meeting_id)->
    @perform 'send_image', image: image, filename: filename, id: meeting_id
