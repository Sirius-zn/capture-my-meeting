App.meeting = App.cable.subscriptions.create {
  channel: "MeetingChannel"
  id: window.meeting.id
},
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    if data != undefined && data['status'] == true
      currImg = data['image'];
      $("img", $("#meeting")).attr("src", currImg);

  send_image: (filename, image, meeting_id, coordSrc, coordEnd)->
    @perform 'send_image', image: image, filename: filename, id: meeting_id, src: coordSrc, end: coordEnd
