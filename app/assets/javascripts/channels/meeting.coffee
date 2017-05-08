App.meeting = App.cable.subscriptions.create {
  channel: "MeetingChannel"
  id: window.meeting.id
},
  connected: ->
    # Called when the subscription is ready for use on the server
    foo()
    begin

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log(data);
    if(data['peers'])
      console.log 'peers: ', data['peers']
      call_all_peers(data['peers'])
    if data != undefined && data['status'] == true
      currImg = data['image'];
      $("img", $("#meeting")).attr("src", currImg);

  send_peer_id: (meeting_id, peer_id) ->
    @perform 'send_peer_id', peer_id: peer_id, meeting_id: window.meeting.id

  send_image: (filename, image, meeting_id, coordSrc, coordEnd)->
    @perform 'send_image', image: image, filename: filename, id: meeting_id, src: coordSrc, end: coordEnd



foo = () ->
  console.log "Hello World "
  console.log "Sending pid"
  peer = new Peer
    key: window.meeting.api_key

  peer.on 'open', (id) ->
    App.meeting.send_peer_id window.meeting.id, id
