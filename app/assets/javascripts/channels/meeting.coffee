App.meeting = App.cable.subscriptions.create {
    channel: "MeetingChannel"
    id: window.meeting.id
    uid: window.meeting.current_id
},
    connected: ->
        # Called when the subscription is ready for use on the server
        App.meeting.get_image(window.meeting.current_id, window.meeting.id)
        if window.meeting.role == "presenter"
            takeSnapshot()


    disconnected: ->
        # Called when the subscription has been terminated by the server

    received: (data) ->
        # Return from get_image function
        if data['from'] == "get_image"
            console.log "Image queried"
            if (data['status'] == true)
                currImg = data['image'];
                $("img", $("#meeting")).attr("src", currImg);

            App.meeting.get_image(window.meeting.current_id, window.meeting.id)

        # Return from send_image function
        if data['from'] == "send_image"
            console.log "Image saved."
            takeSnapshot()

    send_image: (user_id, filename, image, meeting_id) ->
        @perform 'send_image', user_id: user_id, image: image, filename: filename, id: meeting_id

    send_box: (user_id, meeting_id, coordSrc, coordEnd) ->
        @perform 'send_box', user_id: user_id, meeting_id: meeting_id, src: coordSrc, dest: coordEnd

    get_image: (user_id, meeting_id) ->
        @perform 'get_image', user_id: user_id, meeting_id: meeting_id
